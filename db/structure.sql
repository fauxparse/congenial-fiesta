SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: festivals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE festivals (
    id bigint NOT NULL,
    year integer,
    start_date date,
    end_date date
);


--
-- Name: festivals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE festivals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: festivals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE festivals_id_seq OWNED BY festivals.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE identities (
    id bigint NOT NULL,
    participant_id bigint,
    type character varying,
    provider character varying(64),
    uuid character varying(64),
    password_digest character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE participants (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE participants_id_seq OWNED BY participants.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: festivals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY festivals ALTER COLUMN id SET DEFAULT nextval('festivals_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants ALTER COLUMN id SET DEFAULT nextval('participants_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: festivals festivals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY festivals
    ADD CONSTRAINT festivals_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_festivals_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_festivals_on_year ON festivals USING btree (year);


--
-- Name: index_identities_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_participant_id ON identities USING btree (participant_id);


--
-- Name: index_identities_on_participant_id_and_type_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_participant_id_and_type_and_provider ON identities USING btree (participant_id, type, provider);


--
-- Name: index_identities_on_provider_and_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_provider_and_uuid ON identities USING btree (provider, uuid);


--
-- Name: index_participants_on_lowercase_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_participants_on_lowercase_email ON participants USING btree (lower((email)::text));


--
-- Name: identities fk_rails_27e74d7b52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT fk_rails_27e74d7b52 FOREIGN KEY (participant_id) REFERENCES participants(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180319024434'),
('20180319221013'),
('20180319223809'),
('20180319225055');


