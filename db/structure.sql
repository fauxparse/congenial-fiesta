SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
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


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id bigint NOT NULL,
    festival_id bigint,
    pitch_id bigint,
    type character varying,
    name character varying,
    slug character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    maximum integer DEFAULT 16
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: festivals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.festivals (
    id bigint NOT NULL,
    year integer,
    start_date date,
    end_date date,
    pitches_open_at timestamp without time zone,
    pitches_close_at timestamp without time zone,
    registrations_open_at timestamp without time zone,
    earlybird_cutoff timestamp without time zone
);


--
-- Name: festivals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.festivals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: festivals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.festivals_id_seq OWNED BY public.festivals.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id bigint NOT NULL,
    participant_id bigint,
    type character varying,
    provider character varying(64),
    uid character varying(64),
    password_digest character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    admin boolean DEFAULT false,
    company character varying,
    city character varying,
    country_code character varying,
    bio text
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_resets (
    id bigint NOT NULL,
    participant_id bigint,
    token character varying,
    created_at timestamp without time zone,
    expires_at timestamp without time zone
);


--
-- Name: password_resets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.password_resets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: password_resets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.password_resets_id_seq OWNED BY public.password_resets.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    registration_id bigint,
    amount_cents integer DEFAULT 0,
    state character varying DEFAULT 'pending'::character varying,
    reference character varying,
    details json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    kind character varying(32) DEFAULT 'internet_banking'::character varying
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: pitches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pitches (
    id bigint NOT NULL,
    participant_id bigint,
    status character varying(16) DEFAULT 'draft'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    info jsonb,
    festival_id bigint,
    pile character varying DEFAULT 'unsorted'::character varying
);


--
-- Name: pitches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pitches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pitches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pitches_id_seq OWNED BY public.pitches.id;


--
-- Name: presenters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.presenters (
    id bigint NOT NULL,
    activity_id bigint,
    participant_id bigint
);


--
-- Name: presenters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.presenters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: presenters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.presenters_id_seq OWNED BY public.presenters.id;


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registrations (
    id bigint NOT NULL,
    festival_id bigint,
    participant_id bigint,
    state character varying DEFAULT 'pending'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code_of_conduct_accepted_at timestamp without time zone,
    workshops_saved_at timestamp without time zone,
    shows_saved_at timestamp without time zone,
    completed_at timestamp without time zone
);


--
-- Name: registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.registrations_id_seq OWNED BY public.registrations.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id bigint NOT NULL,
    activity_id bigint,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    venue_id bigint,
    maximum integer,
    freebie boolean DEFAULT false
);


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedules_id_seq OWNED BY public.schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: selections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.selections (
    id bigint NOT NULL,
    registration_id bigint,
    schedule_id bigint,
    state character varying(16) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slot character varying,
    "position" integer DEFAULT 1
);


--
-- Name: selections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.selections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.selections_id_seq OWNED BY public.selections.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_type character varying,
    taggable_id integer,
    tagger_type character varying,
    tagger_id integer,
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venues (
    id bigint NOT NULL,
    name character varying,
    address character varying,
    latitude numeric(15,10),
    longitude numeric(15,10)
);


--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venues_id_seq OWNED BY public.venues.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: festivals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.festivals ALTER COLUMN id SET DEFAULT nextval('public.festivals_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: password_resets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets ALTER COLUMN id SET DEFAULT nextval('public.password_resets_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: pitches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitches ALTER COLUMN id SET DEFAULT nextval('public.pitches_id_seq'::regclass);


--
-- Name: presenters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenters ALTER COLUMN id SET DEFAULT nextval('public.presenters_id_seq'::regclass);


--
-- Name: registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations ALTER COLUMN id SET DEFAULT nextval('public.registrations_id_seq'::regclass);


--
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN id SET DEFAULT nextval('public.schedules_id_seq'::regclass);


--
-- Name: selections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selections ALTER COLUMN id SET DEFAULT nextval('public.selections_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues ALTER COLUMN id SET DEFAULT nextval('public.venues_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: festivals festivals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.festivals
    ADD CONSTRAINT festivals_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: pitches pitches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitches
    ADD CONSTRAINT pitches_pkey PRIMARY KEY (id);


--
-- Name: presenters presenters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenters
    ADD CONSTRAINT presenters_pkey PRIMARY KEY (id);


--
-- Name: registrations registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT registrations_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: selections selections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selections
    ADD CONSTRAINT selections_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: venues venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: by_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_activity_type ON public.pitches USING btree ((((info -> 'activity'::text) ->> 'type'::text)));


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_activities_on_festival_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_festival_id ON public.activities USING btree (festival_id);


--
-- Name: index_activities_on_festival_id_and_type_and_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_activities_on_festival_id_and_type_and_slug ON public.activities USING btree (festival_id, type, slug);


--
-- Name: index_activities_on_pitch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_pitch_id ON public.activities USING btree (pitch_id);


--
-- Name: index_festivals_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_festivals_on_year ON public.festivals USING btree (year);


--
-- Name: index_identities_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_participant_id ON public.identities USING btree (participant_id);


--
-- Name: index_identities_on_participant_id_and_type_and_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_participant_id_and_type_and_provider ON public.identities USING btree (participant_id, type, provider);


--
-- Name: index_identities_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_provider_and_uid ON public.identities USING btree (provider, uid);


--
-- Name: index_participants_on_lowercase_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_participants_on_lowercase_email ON public.participants USING btree (lower((email)::text));


--
-- Name: index_password_resets_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_password_resets_on_participant_id ON public.password_resets USING btree (participant_id);


--
-- Name: index_password_resets_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_password_resets_on_token ON public.password_resets USING btree (token);


--
-- Name: index_password_resets_on_token_and_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_password_resets_on_token_and_expires_at ON public.password_resets USING btree (token, expires_at);


--
-- Name: index_payments_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_registration_id ON public.payments USING btree (registration_id);


--
-- Name: index_pitches_on_festival_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitches_on_festival_id ON public.pitches USING btree (festival_id);


--
-- Name: index_pitches_on_festival_id_and_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitches_on_festival_id_and_participant_id ON public.pitches USING btree (festival_id, participant_id);


--
-- Name: index_pitches_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitches_on_participant_id ON public.pitches USING btree (participant_id);


--
-- Name: index_pitches_on_status_and_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pitches_on_status_and_participant_id ON public.pitches USING btree (status, participant_id);


--
-- Name: index_presenters_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_presenters_on_activity_id ON public.presenters USING btree (activity_id);


--
-- Name: index_presenters_on_activity_id_and_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_presenters_on_activity_id_and_participant_id ON public.presenters USING btree (activity_id, participant_id);


--
-- Name: index_presenters_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_presenters_on_participant_id ON public.presenters USING btree (participant_id);


--
-- Name: index_registrations_on_festival_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registrations_on_festival_id ON public.registrations USING btree (festival_id);


--
-- Name: index_registrations_on_festival_id_and_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_registrations_on_festival_id_and_participant_id ON public.registrations USING btree (festival_id, participant_id);


--
-- Name: index_registrations_on_festival_id_and_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registrations_on_festival_id_and_state ON public.registrations USING btree (festival_id, state);


--
-- Name: index_registrations_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registrations_on_participant_id ON public.registrations USING btree (participant_id);


--
-- Name: index_schedules_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_activity_id ON public.schedules USING btree (activity_id);


--
-- Name: index_schedules_on_starts_at_and_ends_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_starts_at_and_ends_at ON public.schedules USING btree (starts_at, ends_at);


--
-- Name: index_schedules_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_venue_id ON public.schedules USING btree (venue_id);


--
-- Name: index_selections_on_registration_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selections_on_registration_id ON public.selections USING btree (registration_id);


--
-- Name: index_selections_on_registration_id_and_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_selections_on_registration_id_and_schedule_id ON public.selections USING btree (registration_id, schedule_id);


--
-- Name: index_selections_on_registration_id_and_slot_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selections_on_registration_id_and_slot_and_position ON public.selections USING btree (registration_id, slot, "position");


--
-- Name: index_selections_on_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selections_on_schedule_id ON public.selections USING btree (schedule_id);


--
-- Name: index_selections_on_schedule_id_and_state_and_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_selections_on_schedule_id_and_state_and_updated_at ON public.selections USING btree (schedule_id, state, updated_at);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_venues_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venues_on_latitude_and_longitude ON public.venues USING btree (latitude, longitude);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: schedules fk_rails_26cbb5018a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT fk_rails_26cbb5018a FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: identities fk_rails_27e74d7b52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_rails_27e74d7b52 FOREIGN KEY (participant_id) REFERENCES public.participants(id) ON DELETE CASCADE;


--
-- Name: password_resets fk_rails_286b6e4fd3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT fk_rails_286b6e4fd3 FOREIGN KEY (participant_id) REFERENCES public.participants(id) ON DELETE CASCADE;


--
-- Name: selections fk_rails_2c18b93dc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selections
    ADD CONSTRAINT fk_rails_2c18b93dc1 FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;


--
-- Name: selections fk_rails_41dbad5a49; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selections
    ADD CONSTRAINT fk_rails_41dbad5a49 FOREIGN KEY (registration_id) REFERENCES public.registrations(id) ON DELETE CASCADE;


--
-- Name: registrations fk_rails_4604f69f81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fk_rails_4604f69f81 FOREIGN KEY (festival_id) REFERENCES public.festivals(id) ON DELETE CASCADE;


--
-- Name: presenters fk_rails_51807902f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenters
    ADD CONSTRAINT fk_rails_51807902f4 FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: registrations fk_rails_621cdb63fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT fk_rails_621cdb63fe FOREIGN KEY (participant_id) REFERENCES public.participants(id) ON DELETE CASCADE;


--
-- Name: pitches fk_rails_b8c4f77d16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitches
    ADD CONSTRAINT fk_rails_b8c4f77d16 FOREIGN KEY (participant_id) REFERENCES public.participants(id) ON DELETE CASCADE;


--
-- Name: payments fk_rails_bb9133230f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_bb9133230f FOREIGN KEY (registration_id) REFERENCES public.registrations(id) ON DELETE RESTRICT;


--
-- Name: presenters fk_rails_c1df69d950; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.presenters
    ADD CONSTRAINT fk_rails_c1df69d950 FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: schedules fk_rails_ce75c0542b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT fk_rails_ce75c0542b FOREIGN KEY (venue_id) REFERENCES public.venues(id) ON DELETE SET NULL;


--
-- Name: activities fk_rails_d55f2d8599; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_rails_d55f2d8599 FOREIGN KEY (festival_id) REFERENCES public.festivals(id) ON DELETE CASCADE;


--
-- Name: pitches fk_rails_faa4f9f838; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pitches
    ADD CONSTRAINT fk_rails_faa4f9f838 FOREIGN KEY (festival_id) REFERENCES public.festivals(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180319024434'),
('20180319221013'),
('20180319223809'),
('20180319225055'),
('20180320203311'),
('20180324023927'),
('20180325021806'),
('20180328195718'),
('20180329202221'),
('20180422030819'),
('20180501040856'),
('20180523225441'),
('20180526000102'),
('20180617013242'),
('20180622212758'),
('20180623025041'),
('20180706031108'),
('20180714012643'),
('20180714012644'),
('20180714012645'),
('20180714012646'),
('20180714012647'),
('20180714012648'),
('20180715212859'),
('20180718001951'),
('20180724212201'),
('20180811220916'),
('20180811222021'),
('20180812205342'),
('20180820211405'),
('20180824201155'),
('20180824203055'),
('20180825010126'),
('20180825120959'),
('20180825205149'),
('20180825223748'),
('20180825224326'),
('20180826000751'),
('20180826013354'),
('20180831014046');


