-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.bill (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id_user integer,
  total double precision,
  date timestamp without time zone,
  CONSTRAINT bill_pkey PRIMARY KEY (id),
  CONSTRAINT fkl555fe2abhoghoveainiqhobe FOREIGN KEY (id_user) REFERENCES public.users(id)
);
CREATE TABLE public.bill_detail (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id_bill integer,
  id_product integer,
  price double precision,
  quality integer,
  subtotal double precision,
  CONSTRAINT bill_detail_pkey PRIMARY KEY (id),
  CONSTRAINT fkiu3wwq39mr69wsbklret9mtki FOREIGN KEY (id_bill) REFERENCES public.bill(id),
  CONSTRAINT fktf4rg7xeewaym8bcjs90wgsns FOREIGN KEY (id_product) REFERENCES public.product(id)
);
CREATE TABLE public.category (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  description character varying,
  name character varying,
  CONSTRAINT category_pkey PRIMARY KEY (id)
);
CREATE TABLE public.person (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  email character varying,
  first_name character varying,
  last_name character varying,
  CONSTRAINT person_pkey PRIMARY KEY (id)
);
CREATE TABLE public.product (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id_category integer,
  price double precision,
  description character varying,
  name character varying,
  CONSTRAINT product_pkey PRIMARY KEY (id),
  CONSTRAINT fk5cxv31vuhc7v32omftlxa8k3c FOREIGN KEY (id_category) REFERENCES public.category(id)
);
CREATE TABLE public.role (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  description character varying,
  name character varying,
  CONSTRAINT role_pkey PRIMARY KEY (id)
);
CREATE TABLE public.user_role (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id_role integer,
  id_user integer,
  CONSTRAINT user_role_pkey PRIMARY KEY (id),
  CONSTRAINT fk2aam9nt2tv8vcfymi3jo9c314 FOREIGN KEY (id_role) REFERENCES public.role(id),
  CONSTRAINT fkr53t650tbjk5yipcm228wf1nc FOREIGN KEY (id_user) REFERENCES public.users(id)
);
CREATE TABLE public.users (
  id integer GENERATED ALWAYS AS IDENTITY NOT NULL,
  id_person integer UNIQUE,
  password character varying,
  username character varying,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT fk1flea6ymfdk8htgkj77xpn3bb FOREIGN KEY (id_person) REFERENCES public.person(id)
);