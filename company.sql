--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Debian 16.9-1.pgdg120+1)
-- Dumped by pg_dump version 16.9 (Debian 16.9-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: notification_events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.notification_events (
    id integer NOT NULL,
    notification_id integer,
    event_type character varying(50) NOT NULL,
    payload jsonb,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.notification_events OWNER TO admin;

--
-- Name: notification_events_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.notification_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_events_id_seq OWNER TO admin;

--
-- Name: notification_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.notification_events_id_seq OWNED BY public.notification_events.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    channel character varying(20) NOT NULL,
    recipient character varying(255) NOT NULL,
    template integer,
    payload jsonb,
    status character varying(30) NOT NULL,
    retry_count integer DEFAULT 0,
    idempotency_key character varying(255),
    schedule_at timestamp without time zone,
    sent_at timestamp without time zone,
    delivered_at timestamp without time zone,
    failed_at timestamp without time zone,
    failure_reason text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO admin;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO admin;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: templates; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.templates (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    channel character varying(20) NOT NULL,
    content text NOT NULL
);


ALTER TABLE public.templates OWNER TO admin;

--
-- Name: templates_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.templates_id_seq OWNER TO admin;

--
-- Name: templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.templates_id_seq OWNED BY public.templates.id;


--
-- Name: notification_events id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notification_events ALTER COLUMN id SET DEFAULT nextval('public.notification_events_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: templates id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.templates ALTER COLUMN id SET DEFAULT nextval('public.templates_id_seq'::regclass);


--
-- Data for Name: notification_events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notification_events (id, notification_id, event_type, payload, created_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.notifications (id, channel, recipient, template, payload, status, retry_count, idempotency_key, schedule_at, sent_at, delivered_at, failed_at, failure_reason, created_at, updated_at) FROM stdin;
1	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Hi"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-08 10:09:19.155717	2026-06-08 10:09:19.155717
2	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Hi"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:02:29.214765	2026-06-15 09:02:29.214765
3	EMAIL	test@gmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:04:30.866137	2026-06-15 09:04:30.866137
4	EMAIL	test@gmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:09:20.595398	2026-06-15 09:09:20.595398
5	EMAIL	test@gmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:13:20.180972	2026-06-15 09:13:20.180972
6	EMAIL	test@gmail.com	2	{"kevin": "kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:17:19.003175	2026-06-15 09:17:19.003175
7	EMAIL	test@gmail.com	2	{"kevin": "kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:21:06.315405	2026-06-15 09:21:06.315405
8	EMAIL	test@gmail.com	2	{"kevin": "kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-15 09:26:58.626811	2026-06-15 09:26:58.626811
9	EMAIL	test@gmail.com	2	{"kevin": "kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:48:27.51984	2026-06-18 12:48:27.51984
10	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:04.730373	2026-06-18 12:50:04.730373
11	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:09.199305	2026-06-18 12:50:09.199305
12	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:10.134038	2026-06-18 12:50:10.134038
13	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:10.93334	2026-06-18 12:50:10.93334
14	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:11.67185	2026-06-18 12:50:11.67185
15	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:12.716171	2026-06-18 12:50:12.716171
16	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:13.589329	2026-06-18 12:50:13.589329
17	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:14.491995	2026-06-18 12:50:14.491995
18	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:15.228201	2026-06-18 12:50:15.228201
19	EMAIL	kevaron_28@hotmail.com	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-18 12:50:15.892026	2026-06-18 12:50:15.892026
20	EMAIL	test	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-30 09:08:45.184391	2026-06-30 09:08:45.184391
21	EMAIL	test	2	{"kevin": "Kevin"}	CREATED	0	\N	\N	\N	\N	\N	\N	2026-06-30 09:08:51.566245	2026-06-30 09:08:51.566245
\.


--
-- Data for Name: templates; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.templates (id, name, channel, content) FROM stdin;
2	test-template	EMAIL	Hi {{kevin}}
3	template-email	SMS	Hi {{kevin}}
\.


--
-- Name: notification_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.notification_events_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.notifications_id_seq', 21, true);


--
-- Name: templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.templates_id_seq', 5, true);


--
-- Name: notification_events notification_events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notification_events
    ADD CONSTRAINT notification_events_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: templates templates_name_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_name_key UNIQUE (name);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);


--
-- Name: notification_events notification_events_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notification_events
    ADD CONSTRAINT notification_events_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id);


--
-- Name: notifications notifications_template_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_template_fkey FOREIGN KEY (template) REFERENCES public.templates(id);


--
-- PostgreSQL database dump complete
--

