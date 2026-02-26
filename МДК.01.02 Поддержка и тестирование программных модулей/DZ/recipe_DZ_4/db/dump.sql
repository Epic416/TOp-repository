--
-- PostgreSQL database dump
--

\restrict 8F5xgVG66PwFd7ZDnrCCeH1Zv6JqV5KjpByW6i3GzStPrNADNJP0ALBCruNwt48

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-02-19 12:13:28

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

--
-- TOC entry 6 (class 2615 OID 16388)
-- Name: recipes; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA recipes;


ALTER SCHEMA recipes OWNER TO postgres;

--
-- TOC entry 863 (class 1247 OID 16404)
-- Name: levels; Type: TYPE; Schema: recipes; Owner: postgres
--

CREATE TYPE recipes.levels AS ENUM (
    'enum',
    'medium',
    'hard',
    'unreal'
);


ALTER TYPE recipes.levels OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 16414)
-- Name: categories; Type: TABLE; Schema: recipes; Owner: postgres
--

CREATE TABLE recipes.categories (
    id integer NOT NULL,
    name character varying(45) NOT NULL
);


ALTER TABLE recipes.categories OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16413)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: recipes; Owner: postgres
--

CREATE SEQUENCE recipes.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE recipes.categories_id_seq OWNER TO postgres;

--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: recipes; Owner: postgres
--

ALTER SEQUENCE recipes.categories_id_seq OWNED BY recipes.categories.id;


--
-- TOC entry 225 (class 1259 OID 16423)
-- Name: ingridients; Type: TABLE; Schema: recipes; Owner: postgres
--

CREATE TABLE recipes.ingridients (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text
);


ALTER TABLE recipes.ingridients OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16422)
-- Name: ingridients_id_seq; Type: SEQUENCE; Schema: recipes; Owner: postgres
--

CREATE SEQUENCE recipes.ingridients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE recipes.ingridients_id_seq OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 224
-- Name: ingridients_id_seq; Type: SEQUENCE OWNED BY; Schema: recipes; Owner: postgres
--

ALTER SEQUENCE recipes.ingridients_id_seq OWNED BY recipes.ingridients.id;


--
-- TOC entry 227 (class 1259 OID 16434)
-- Name: recipes; Type: TABLE; Schema: recipes; Owner: postgres
--

CREATE TABLE recipes.recipes (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    level recipes.levels,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    category_id integer
);


ALTER TABLE recipes.recipes OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16433)
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: recipes; Owner: postgres
--

CREATE SEQUENCE recipes.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE recipes.recipes_id_seq OWNER TO postgres;

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 226
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: recipes; Owner: postgres
--

ALTER SEQUENCE recipes.recipes_id_seq OWNED BY recipes.recipes.id;


--
-- TOC entry 228 (class 1259 OID 16445)
-- Name: recipes_ingridients; Type: TABLE; Schema: recipes; Owner: postgres
--

CREATE TABLE recipes.recipes_ingridients (
    recipe_id integer NOT NULL,
    ingridient_id integer NOT NULL
);


ALTER TABLE recipes.recipes_ingridients OWNER TO postgres;

--
-- TOC entry 4777 (class 2604 OID 16417)
-- Name: categories id; Type: DEFAULT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.categories ALTER COLUMN id SET DEFAULT nextval('recipes.categories_id_seq'::regclass);


--
-- TOC entry 4778 (class 2604 OID 16426)
-- Name: ingridients id; Type: DEFAULT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.ingridients ALTER COLUMN id SET DEFAULT nextval('recipes.ingridients_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 16437)
-- Name: recipes id; Type: DEFAULT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.recipes ALTER COLUMN id SET DEFAULT nextval('recipes.recipes_id_seq'::regclass);


--
-- TOC entry 4938 (class 0 OID 16414)
-- Dependencies: 223
-- Data for Name: categories; Type: TABLE DATA; Schema: recipes; Owner: postgres
--

COPY recipes.categories (id, name) FROM stdin;
1	Завтраки
2	Обеды
3	Ужины
4	Десерты
5	Салаты
6	Супы
7	Выпечка
8	Закуски
\.


--
-- TOC entry 4940 (class 0 OID 16423)
-- Dependencies: 225
-- Data for Name: ingridients; Type: TABLE DATA; Schema: recipes; Owner: postgres
--

COPY recipes.ingridients (id, name, description) FROM stdin;
1	Мука	Пшеничная высшего сорта
2	Сахар	Гранулированный белый сахар
3	Яйца	Куриные яйца
4	Молоко	Коровье молоко 3.2%
5	Масло сливочное	Сливочное масло 82.5%
6	Соль	Поваренная соль
7	Куриное филе	Охлаждённое куриное филе
8	Картофель	Картофель средний
9	Лук репчатый	Жёлтый лук
10	Чеснок	Свежий чеснок
11	Помидоры	Свежие помидоры
12	Огурцы	Свежие огурцы
13	Сыр	Твёрдый сыр
14	Растительное масло	Подсолнечное масло
15	Специи	Смесь перцев и трав
16	Мёд	Натуральный цветочный мёд
17	Шоколад	Чёрный шоколад 70%
18	Сливки	Жирные сливки 33%
19	Грибы	Шампиньоны свежие
20	Зелень	Петрушка и укроп
\.


--
-- TOC entry 4942 (class 0 OID 16434)
-- Dependencies: 227
-- Data for Name: recipes; Type: TABLE DATA; Schema: recipes; Owner: postgres
--

COPY recipes.recipes (id, name, description, level, created_at, category_id) FROM stdin;
9	Паста Карбонара	Итальянская паста с беконом, яйцами и пармезаном. Сварить спагетти, обжарить гуанчале, смешать с яичной смесью и сыром.	medium	2026-02-05 13:44:16.263345	\N
10	Макароны по-флотски	Простое и сытное блюдо из макарон и фарша. Обжарить фарш с луком, смешать с отварными макаронами.	enum	2026-02-06 13:44:16.263345	\N
11	Чизкейк Нью-Йорк	Плотный и сливочный американский чизкейк. Приготовить основу из печенья, начинку из сливочного сыра, запечь на водяной бане.	hard	2026-02-07 13:44:16.263345	\N
12	Оливье	Классический русский салат на праздничный стол. Отварить овощи и яйца, нарезать кубиками, добавить колбасу и заправить майонезом.	enum	2026-02-08 13:44:16.263345	\N
13	Суфле из белков	Воздушный десерт из яичных белков и сахара. Взбить белки с сахаром до устойчивых пиков, запечь при низкой температуре.	hard	2026-02-09 13:44:16.263345	\N
14	Медовик	Слоёный торт с мёдом и сметанным кремом. Испечь тонкие коржи на основе мёда и сгущёнки, промазать сметанным кремом.	unreal	2026-02-10 13:44:16.263345	\N
15	Французские круассаны	Слоёные круассаны с маслянистой текстурой. Приготовить заварное тесто, сделать ламинирование с маслом, раскатать, скрутить и выпекать.	unreal	2026-02-11 13:44:16.263345	\N
1	Омлет классический	Простой и вкусный завтрак для всей семьи. Взбить яйца с молоком, добавить соль и жарить на сковороде до готовности.	enum	2026-01-28 13:44:16.263345	1
2	Блины на молоке	Тонкие блины с дырочками. Смешать муку, молоко, яйца, сахар и соль. Жарить на разогретой сковороде с маслом.	enum	2026-01-29 13:44:16.263345	4
3	Салат Цезарь	Классический салат с курицей, сыром пармезан и гренками. Заправить соусом из яичного желтка, чеснока и анчоусов.	medium	2026-01-30 13:44:16.263345	5
4	Картофельное пюре	Нежное картофельное пюре с маслом и молоком. Отварить картофель, размять, добавить тёплое молоко и сливочное масло.	enum	2026-01-31 13:44:16.263345	3
5	Курица с грибами в сливочном соусе	Сочное куриное филе с шампиньонами в ароматном сливочном соусе. Обжарить курицу, добавить грибы, залить сливками и тушить.	medium	2026-02-01 13:44:16.263345	3
6	Шоколадный торт	Богатый шоколадный торт с нежным кремом. Приготовить бисквит на основе тёмного шоколада, прослоить кремом из сливочного масла и сгущёнки.	medium	2026-02-02 13:44:16.263345	4
7	Борщ	Традиционный украинский борщ с свёклой и говядиной. Варить бульон, добавить овощи, заправить чесноком и зеленью.	hard	2026-02-03 13:44:16.263345	6
8	Окрошка на квасе	Летний холодный суп с огурцами, яйцами и колбасой. Нарезать ингредиенты кубиками, залить квасом и кефиром.	enum	2026-02-04 13:44:16.263345	5
\.


--
-- TOC entry 4943 (class 0 OID 16445)
-- Dependencies: 228
-- Data for Name: recipes_ingridients; Type: TABLE DATA; Schema: recipes; Owner: postgres
--

COPY recipes.recipes_ingridients (recipe_id, ingridient_id) FROM stdin;
1	3
1	4
1	6
2	1
2	3
2	4
2	2
2	6
3	7
3	3
3	13
3	20
3	10
4	8
4	5
4	4
4	6
5	7
5	19
5	18
5	9
5	10
5	6
6	1
6	2
6	3
6	5
6	17
7	8
7	9
7	10
7	11
7	20
7	6
8	11
8	12
8	3
8	20
9	1
9	3
9	13
9	10
10	1
10	7
10	9
10	6
11	1
11	2
11	3
11	5
11	13
12	8
12	3
12	11
12	12
12	20
13	3
13	2
14	1
14	2
14	3
\.


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 222
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: recipes; Owner: postgres
--

SELECT pg_catalog.setval('recipes.categories_id_seq', 8, true);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 224
-- Name: ingridients_id_seq; Type: SEQUENCE SET; Schema: recipes; Owner: postgres
--

SELECT pg_catalog.setval('recipes.ingridients_id_seq', 20, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 226
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: recipes; Owner: postgres
--

SELECT pg_catalog.setval('recipes.recipes_id_seq', 15, true);


--
-- TOC entry 4782 (class 2606 OID 16421)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4784 (class 2606 OID 16432)
-- Name: ingridients ingridients_pkey; Type: CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.ingridients
    ADD CONSTRAINT ingridients_pkey PRIMARY KEY (id);


--
-- TOC entry 4786 (class 2606 OID 16444)
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 16460)
-- Name: recipes recipes_category_id_fkey; Type: FK CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.recipes
    ADD CONSTRAINT recipes_category_id_fkey FOREIGN KEY (category_id) REFERENCES recipes.categories(id);


--
-- TOC entry 4788 (class 2606 OID 16455)
-- Name: recipes_ingridients recipes_ingridients_ingridient_id_fkey; Type: FK CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.recipes_ingridients
    ADD CONSTRAINT recipes_ingridients_ingridient_id_fkey FOREIGN KEY (ingridient_id) REFERENCES recipes.ingridients(id);


--
-- TOC entry 4789 (class 2606 OID 16450)
-- Name: recipes_ingridients recipes_ingridients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: recipes; Owner: postgres
--

ALTER TABLE ONLY recipes.recipes_ingridients
    ADD CONSTRAINT recipes_ingridients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES recipes.recipes(id);


-- Completed on 2026-02-19 12:13:29

--
-- PostgreSQL database dump complete
--

\unrestrict 8F5xgVG66PwFd7ZDnrCCeH1Zv6JqV5KjpByW6i3GzStPrNADNJP0ALBCruNwt48

