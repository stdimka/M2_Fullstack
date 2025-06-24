import json
import logging
import os
import re

from http.server import BaseHTTPRequestHandler, HTTPServer
from pprint import pprint
from typing import Optional
from urllib.parse import urlparse, parse_qs

from db_manager import postgres_config, PostgresManager


HOST = '0.0.0.0'
PORT = 8000

class ImageServer(BaseHTTPRequestHandler):
    db: Optional[PostgresManager] = None

    def do_GET(self):

        # для пагинации меняем self.path (путь с параметрами) на path ("чистый" путь)
        parsed_url = urlparse(self.path)        # /api/images?page=2
        path = parsed_url.path                  # например, /api/images
        query_params = parse_qs(parsed_url.query)
        page = int(query_params.get('page', [1])[0])  # если ?page=2 → 2, иначе 1


        if path == '/':
            self.serve_file('index.html', 'text/html')
            logging.info('Main page accessed')
        elif path == '/upload':
            self.serve_file('./upload.html', 'text/html')
            logging.info('Upload page accessed')
        elif path == '/images-list':
            self.serve_file('./images.html', 'text/html')

        # добавляем ссылку для запроса по AJAX:
        elif path == '/api/get-data':
            total, data = ImageServer.db.get_page_by_page_num(page, is_print=False)
            print("total:", total, "data:", data)
            # [("cat.png", "url", "10kb", "2025-10-10", "jpg"),
            # ...]
            json_data = {
                "items": [
                    {
                        "id": row[0],
                        "name": row[1],
                        "original_name": row[2],
                        "size": row[3],
                        "uploaded_at": row[4].strftime('%Y-%m-%d %H:%M:%S'),
                        "type": row[5]
                    }
                    for row in data
                ],
                "total": total,
                "page": page,
            }

            print('==================== json_data: ===================')
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(json_data).encode('utf-8'))

        else:
            self.send_error(404, 'Not Found')

    def do_POST(self):
        # print(f"Received POST: {self.path}")
        if self.path.startswith("/delete/"):
            match = re.match(r"^/delete/(\d+)/$", self.path)
            print("Есть совпадение!")
            if match:
                image_id = match.group(1)
                print(f"Удаление изображения с ID {image_id}")

                # Например, удалим файл по ID (предположим, что имя совпадает)
                try:
                    # 1. Находим имя по id
                    filename = ImageServer.db.get_id_by_filename(image_id)
                    print(f'Файл {filename} по ID {image_id}  успешно найден!')

                    # 2. Удаляем файл из папки
                    file_path = f"/app/images/{filename}"
                    os.remove(file_path)
                    print(f'Файл {file_path} успешно удалён!')

                    # 3. Удаляем запись из базы
                    ImageServer.db.delete_by_id(image_id)
                    print(f'Файл c ID {image_id} успешно удалён из БД!')

                    self.send_response(200)
                    self.end_headers()
                    self.wfile.write(b"Deleted")
                except FileNotFoundError:
                    self.send_response(404)
                    self.end_headers()
                    self.wfile.write(b"File not found")
                except Exception as e:
                    self.send_response(500)
                    self.end_headers()
                    self.wfile.write(f"Error: {e}".encode())
            else:
                self.send_response(404)
                self.end_headers()
                self.wfile.write(b"Not found")

    def serve_file(self, filepath, content_type):
        try:
            with open(filepath, 'rb') as f:
                self.send_response(200)
                self.send_header('Content-type', content_type)
                self.end_headers()
                self.wfile.write(f.read())
        except FileNotFoundError:
            self.send_error(404, 'Not Found')


    def send_error_response(self, code, message):
        self.send_response(code)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps({"error": message}).encode('utf-8'))

def run(db_object):
    ImageServer.db = db_object
    """
    Класс HTTPServer сам создаёт экземпляры ImageServer, 
    передавая только аргументы, которые ему нужны. 
    Мы не можете напрямую изменить __init__ в ImageServer, чтобы передать туда pm, 
    потому что HTTPServer этого не поддерживает.
    
    Поэтому создаём промежуточный класс-наследник CustomHandler,
    куда передаём объект подключения в качестве class attribute
    (атрибута класса, а не экземпляра класса)
    """

    server_address = (HOST, PORT)
    httpd = HTTPServer(server_address, ImageServer)
    logging.info('Starting server...')
    httpd.serve_forever()


if __name__ == '__main__':
    with PostgresManager(postgres_config) as pm:
        pm.create_table()
        # files = [f for f in os.listdir('./images_source')]
        # print(*files)
        # for f in files:
        #     pm.add_file(f)

        total_count, rows = pm.get_page_by_page_num(2, is_print=False)
        print("total_count:", total_count)
        print(*rows, sep='\n')


        run(pm)
