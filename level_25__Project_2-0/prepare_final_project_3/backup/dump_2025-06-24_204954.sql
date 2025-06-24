--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg120+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.images (
    id integer NOT NULL,
    filename text NOT NULL,
    original_name text NOT NULL,
    size integer NOT NULL,
    upload_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    file_type text NOT NULL
);


ALTER TABLE public.images OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.images_id_seq OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.images.id;


--
-- Name: images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Data for Name: images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.images (id, filename, original_name, size, upload_time, file_type) FROM stdin;
1	vJl38RSuflaR.png	2.png	205	2025-06-24 16:18:15.573422	png
2	dyxL5WnwJht4.png	4.png	345	2025-06-24 16:18:15.582016	png
3	d1lCrKmhdrhV.png	1.png	216	2025-06-24 16:18:15.589175	png
4	jHjEj2wyZxXM.png	5.png	287	2025-06-24 16:18:15.594023	png
5	vzyOKEFKXvAq.png	3.png	126	2025-06-24 16:18:15.600585	png
6	7qEyJIbXWIUA.png	2.png	205	2025-06-24 16:23:35.233854	png
7	TR8v75H1IPNk.png	4.png	345	2025-06-24 16:23:35.238396	png
8	mS42BNyHJUhz.png	1.png	216	2025-06-24 16:23:35.240364	png
9	slr0TihOgxD0.png	5.png	287	2025-06-24 16:23:35.243386	png
10	8sTbgjlogqRe.png	3.png	126	2025-06-24 16:23:35.244938	png
11	XWFEdK9mkmaE.png	2.png	205	2025-06-24 16:33:44.474105	png
12	Oh9ajuqQLKLX.png	4.png	345	2025-06-24 16:33:44.481107	png
13	ZISRSxlZOle4.png	1.png	216	2025-06-24 16:33:44.48468	png
14	E4cxfsMWj0C7.png	5.png	287	2025-06-24 16:33:44.488319	png
15	0gdFfLGqHxsk.png	3.png	126	2025-06-24 16:33:44.494413	png
16	AtKYBd7hboFP.png	2.png	205	2025-06-24 16:43:33.787734	png
17	V7RE8vLMDyN2.png	4.png	345	2025-06-24 16:43:33.79482	png
18	cPljmyjoeWdI.png	1.png	216	2025-06-24 16:43:33.798324	png
19	UCfJ8kcHZLws.png	5.png	287	2025-06-24 16:43:33.800185	png
20	0wZuozGfRtny.png	3.png	126	2025-06-24 16:43:33.801974	png
21	VdIqt6ZgcaoB.png	2.png	205	2025-06-24 16:45:32.210719	png
22	insrgb3aplot.png	4.png	345	2025-06-24 16:45:32.214517	png
23	Gnwyhta4iHJS.png	1.png	216	2025-06-24 16:45:32.216163	png
24	fKDJxNipJsHF.png	5.png	287	2025-06-24 16:45:32.219165	png
25	lujIn5DTQ3Tp.png	3.png	126	2025-06-24 16:45:32.220385	png
26	3Zawhlmz0RfJ.png	2.png	205	2025-06-24 17:03:40.472961	png
27	sKNPvhcx7kIS.png	4.png	345	2025-06-24 17:03:40.488536	png
28	bPZ1nvOVEBxg.png	1.png	216	2025-06-24 17:03:40.491951	png
29	H8u6KaAivSfB.png	5.png	287	2025-06-24 17:03:40.496759	png
30	4b0d2LzglJ4a.png	3.png	126	2025-06-24 17:03:40.500896	png
31	PfyB3wq1TIuo.png	2.png	205	2025-06-24 17:08:47.056072	png
32	OI5dACyxNDTd.png	4.png	345	2025-06-24 17:08:47.061794	png
33	2mcZzv2chyZp.png	1.png	216	2025-06-24 17:08:47.06364	png
\.


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.images_id_seq', 35, true);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

