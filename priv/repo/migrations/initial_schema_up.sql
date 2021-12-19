
CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;



COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';



CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;



COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.allocation_plan_budget_items (
    id integer NOT NULL,
    allocation_plan_id integer NOT NULL,
    budget_item_id integer NOT NULL,
    amount_budgeted numeric(10,2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);



CREATE SEQUENCE public.allocation_plan_budget_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.allocation_plan_budget_items_id_seq OWNED BY public.allocation_plan_budget_items.id;



CREATE TABLE public.allocation_plans (
    id integer NOT NULL,
    budget_id integer NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    income numeric(10,2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);



CREATE SEQUENCE public.allocation_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.allocation_plans_id_seq OWNED BY public.allocation_plans.id;



CREATE TABLE public.annual_budget_items (
    id integer NOT NULL,
    annual_budget_id integer NOT NULL,
    name text NOT NULL,
    due_date date NOT NULL,
    amount numeric(10,2) NOT NULL,
    paid boolean DEFAULT false NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    payment_intervals integer DEFAULT 12 NOT NULL
);



CREATE SEQUENCE public.annual_budget_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.annual_budget_items_id_seq OWNED BY public.annual_budget_items.id;



CREATE TABLE public.annual_budgets (
    id integer NOT NULL,
    user_id integer NOT NULL,
    year integer NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    CONSTRAINT year_range CHECK (((year >= 2013) AND (year <= 2100)))
);



CREATE SEQUENCE public.annual_budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.annual_budgets_id_seq OWNED BY public.annual_budgets.id;





CREATE TABLE public.assets_liabilities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name public.citext NOT NULL,
    is_asset boolean DEFAULT true NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);



CREATE SEQUENCE public.assets_liabilities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.assets_liabilities_id_seq OWNED BY public.assets_liabilities.id;



CREATE TABLE public.budget_categories (
    id integer NOT NULL,
    budget_id integer NOT NULL,
    name text NOT NULL,
    percentage text NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);



CREATE SEQUENCE public.budget_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.budget_categories_id_seq OWNED BY public.budget_categories.id;



CREATE TABLE public.budget_item_expenses (
    id integer NOT NULL,
    budget_item_id integer NOT NULL,
    name text NOT NULL,
    amount numeric(10,2) NOT NULL,
    date date NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);



CREATE SEQUENCE public.budget_item_expenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.budget_item_expenses_id_seq OWNED BY public.budget_item_expenses.id;



CREATE TABLE public.budget_items (
    id integer NOT NULL,
    budget_category_id integer NOT NULL,
    name text NOT NULL,
    amount_budgeted numeric(10,2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    envelope boolean
);



CREATE SEQUENCE public.budget_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.budget_items_id_seq OWNED BY public.budget_items.id;



CREATE TABLE public.budgets (
    id integer NOT NULL,
    month integer NOT NULL,
    monthly_income numeric(10,2) NOT NULL,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    user_id integer NOT NULL,
    year integer NOT NULL,
    CONSTRAINT verify_month CHECK (((month >= 1) AND (month <= 12))),
    CONSTRAINT verify_year CHECK (((year >= 2013) AND (year <= 2200)))
);



CREATE SEQUENCE public.budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;



CREATE TABLE public.net_worth_items (
    id integer NOT NULL,
    net_worth_id integer NOT NULL,
    asset_liability_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL
);



CREATE SEQUENCE public.net_worth_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.net_worth_items_id_seq OWNED BY public.net_worth_items.id;



CREATE TABLE public.net_worths (
    id integer NOT NULL,
    user_id integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,
    CONSTRAINT month_range CHECK (((month >= 1) AND (month <= 12))),
    CONSTRAINT year_range CHECK (((year >= 1900) AND (year <= 2100)))
);



CREATE SEQUENCE public.net_worths_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.net_worths_id_seq OWNED BY public.net_worths.id;
CREATE TABLE public.sessions (
    authentication_key uuid DEFAULT public.gen_random_uuid() NOT NULL,
    authentication_token character varying NOT NULL,
    user_id integer NOT NULL,
    ip character varying NOT NULL,
    user_agent character varying NOT NULL,
    expired_at timestamptz ,
    created_at timestamptz DEFAULT now() NOT NULL,
    updated_at timestamptz DEFAULT now() NOT NULL,
    device_name text,
    push_notification_token text
);
CREATE TABLE public.users (
    id integer NOT NULL,
    password_hash text,
    password_salt text,
    admin boolean,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL,
    password_reset_token text,
    password_reset_sent_at timestamptz,
    email citext NOT NULL unique,
    hashed_password text NOT NULL,
    confirmed_at timestamptz,
    first_name text,
    last_name text,
    reset_password_token text,
    reset_password_sent_at timestamptz,
    remember_created_at timestamptz,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamptz,
    last_sign_in_at timestamptz,
    current_sign_in_ip text,
    last_sign_in_ip text,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamptz
);

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
ALTER TABLE ONLY public.allocation_plan_budget_items ALTER COLUMN id SET DEFAULT nextval('public.allocation_plan_budget_items_id_seq'::regclass);
ALTER TABLE ONLY public.allocation_plans ALTER COLUMN id SET DEFAULT nextval('public.allocation_plans_id_seq'::regclass);
ALTER TABLE ONLY public.annual_budget_items ALTER COLUMN id SET DEFAULT nextval('public.annual_budget_items_id_seq'::regclass);
ALTER TABLE ONLY public.annual_budgets ALTER COLUMN id SET DEFAULT nextval('public.annual_budgets_id_seq'::regclass);
ALTER TABLE ONLY public.assets_liabilities ALTER COLUMN id SET DEFAULT nextval('public.assets_liabilities_id_seq'::regclass);
ALTER TABLE ONLY public.budget_categories ALTER COLUMN id SET DEFAULT nextval('public.budget_categories_id_seq'::regclass);



ALTER TABLE ONLY public.budget_item_expenses ALTER COLUMN id SET DEFAULT nextval('public.budget_item_expenses_id_seq'::regclass);



ALTER TABLE ONLY public.budget_items ALTER COLUMN id SET DEFAULT nextval('public.budget_items_id_seq'::regclass);



ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);



ALTER TABLE ONLY public.net_worth_items ALTER COLUMN id SET DEFAULT nextval('public.net_worth_items_id_seq'::regclass);



ALTER TABLE ONLY public.net_worths ALTER COLUMN id SET DEFAULT nextval('public.net_worths_id_seq'::regclass);



ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);



ALTER TABLE ONLY public.allocation_plan_budget_items
    ADD CONSTRAINT allocation_plan_budget_items_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.allocation_plans
    ADD CONSTRAINT allocation_plans_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.annual_budget_items
    ADD CONSTRAINT annual_budget_items_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.annual_budgets
    ADD CONSTRAINT annual_budgets_pkey PRIMARY KEY (id);






ALTER TABLE ONLY public.assets_liabilities
    ADD CONSTRAINT assets_liabilities_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.assets_liabilities
    ADD CONSTRAINT assets_liabilities_user_id_name_key UNIQUE (user_id, name);



ALTER TABLE ONLY public.budget_categories
    ADD CONSTRAINT budget_categories_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.budget_item_expenses
    ADD CONSTRAINT budget_item_expenses_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_items_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT index_budgets_on_user_id_and_year_and_month UNIQUE (user_id, year, month);



ALTER TABLE ONLY public.net_worth_items
    ADD CONSTRAINT net_worth_items_net_worth_id_asset_liability_id_key UNIQUE (net_worth_id, asset_liability_id);



ALTER TABLE ONLY public.net_worth_items
    ADD CONSTRAINT net_worth_items_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.net_worths
    ADD CONSTRAINT net_worths_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.net_worths
    ADD CONSTRAINT net_worths_user_id_year_month_key UNIQUE (user_id, year, month);



ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (authentication_key);



ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



CREATE INDEX active_sessions_idx ON public.sessions USING btree (authentication_key) WHERE (expired_at IS NULL);



CREATE INDEX allocation_plan_bdgt_itms_alc_id_idx ON public.allocation_plan_budget_items USING btree (allocation_plan_id);



CREATE INDEX allocation_plan_bdgt_itms_budget_id_idx ON public.allocation_plan_budget_items USING btree (budget_item_id);



CREATE INDEX allocation_plans_budget_id_idx ON public.allocation_plans USING btree (budget_id);



CREATE INDEX annual_budget_items_budget_id_idx ON public.annual_budget_items USING btree (annual_budget_id);



CREATE INDEX annual_budgets_user_id_idx ON public.annual_budgets USING btree (user_id);



CREATE INDEX budget_id_idx ON public.budget_categories USING btree (budget_id);



CREATE INDEX budget_item_expenses_item_idx ON public.budget_item_expenses USING btree (budget_item_id);



CREATE INDEX budget_items_category_idx ON public.budget_items USING btree (budget_category_id);



CREATE INDEX budgets_user_id_idx ON public.budgets USING btree (user_id);



CREATE UNIQUE INDEX index_annual_budgets_on_user_id_and_year ON public.annual_budgets USING btree (user_id, year);



CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);



CREATE INDEX sessions_user_id_idx ON public.sessions USING btree (user_id);




ALTER TABLE ONLY public.allocation_plans
    ADD CONSTRAINT allocation_budget_foreign_key FOREIGN KEY (budget_id) REFERENCES public.budgets(id);



ALTER TABLE ONLY public.allocation_plan_budget_items
    ADD CONSTRAINT allocation_budget_itm_foreign_key FOREIGN KEY (budget_item_id) REFERENCES public.budget_items(id);



ALTER TABLE ONLY public.allocation_plan_budget_items
    ADD CONSTRAINT allocation_pln_budget_foreign_key FOREIGN KEY (allocation_plan_id) REFERENCES public.allocation_plans(id);



ALTER TABLE ONLY public.annual_budget_items
    ADD CONSTRAINT annual_budget_foreign_key FOREIGN KEY (annual_budget_id) REFERENCES public.annual_budgets(id);



ALTER TABLE ONLY public.annual_budgets
    ADD CONSTRAINT annual_user_foreign_key FOREIGN KEY (user_id) REFERENCES public.users(id);



ALTER TABLE ONLY public.assets_liabilities
    ADD CONSTRAINT assets_liabilities_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);



ALTER TABLE ONLY public.budget_items
    ADD CONSTRAINT budget_category_foreign_key FOREIGN KEY (budget_category_id) REFERENCES public.budget_categories(id);



ALTER TABLE ONLY public.budget_categories
    ADD CONSTRAINT budget_id_foreign_key FOREIGN KEY (budget_id) REFERENCES public.budgets(id);



ALTER TABLE ONLY public.budget_item_expenses
    ADD CONSTRAINT budget_item_foreign_key FOREIGN KEY (budget_item_id) REFERENCES public.budget_items(id);



ALTER TABLE ONLY public.net_worth_items
    ADD CONSTRAINT net_worth_items_asset_liability_id_fkey FOREIGN KEY (asset_liability_id) REFERENCES public.assets_liabilities(id);



ALTER TABLE ONLY public.net_worth_items
    ADD CONSTRAINT net_worth_items_net_worth_id_fkey FOREIGN KEY (net_worth_id) REFERENCES public.net_worths(id);



ALTER TABLE ONLY public.net_worths
    ADD CONSTRAINT net_worths_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);



ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);



ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT user_foreign_key FOREIGN KEY (user_id) REFERENCES public.users(id);



