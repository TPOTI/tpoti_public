CREATE TABLE orden_proyecto (
    id bigserial NOT NULL,
    orden_id uuid NOT NULL,
    merchant_orden_id text,
    merchant_id text NOT NULL,
    succes_url text,
    pending_url text,
    failure_url text,
    cancel_url text,
    notice_url text,
    orden_tax_amount double precision,
    purchase_country varchar(4),
    purchase_currency varchar(10) NOT NULL,
    orden_delivery_fee double precision,
    orden_pago_fee double precision,
    orden_total_amount double precision NOT NULL,
    birth_date varchar(10),
    gender varchar(6),
    mobile_phone varchar(20) NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    national_id_number varchar(100),
    title varchar(10),
    "type" varchar(10) NOT NULL DEFAULT 'PERSON',
    email text NOT NULL,
    customer_id varchar(20),
    init_timestamp timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    confirm_timestamp timestamp,
    payment_url text,
    accepted_terms boolean,
    terms_timestamp timestamp,
    user_ip_address varchar(15) NOT NULL,
    channel varchar(20) NOT NULL,
    organization_registration_id text,
    organization_name text,
    operacion_id text,
    payment_option VARCHAR(50),
    CONSTRAINT orden_pkey PRIMARY KEY (id)
);

CREATE TABLE orden_proyecto_estatus ( id bigserial NOT NULL, orden_id bigserial NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), status varchar(50) NOT NULL, CONSTRAINT orden_proyecto_estatus_pkey PRIMARY KEY (id) );

ALTER TABLE orden_proyecto_estatus ADD CONSTRAINT orden_proyecto_estatus_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);

CREATE TABLE address (
    id bigserial NOT NULL,
    orden_id bigserial NOT NULL,
    city varchar(200) NOT NULL,
    country varchar(4) NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    organization_name text,
    postal_code varchar(50) NOT NULL,
    region varchar(20),
    street_address text,
    street_address2 text,
    title varchar(10),
    "type" varchar(10) NOT NULL,
    CONSTRAINT address_pkey PRIMARY KEY (id)
);

ALTER TABLE address ADD CONSTRAINT address_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);

CREATE TABLE item (
    id bigserial NOT NULL,
    orden_id bigserial NOT NULL,
    name varchar(100) NOT NULL,
    brand text NULL,
    reference text NOT NULL,
    image_url text NOT NULL,
    quantity integer NOT NULL,
    tax_rate double precision NOT NULL,
    total_amount double precision NOT NULL,
    total_discount_amount double precision NOT NULL,
    total_tax_amount double precision NOT NULL,
    unit_price double precision NOT NULL,
    serial_number text,
    CONSTRAINT item_pkey PRIMARY KEY (id)
);

ALTER TABLE item ADD CONSTRAINT item_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE devolucion ( id bigserial NOT NULL, orden_id bigserial NOT NULL, devolucion_id text NOT NULL, amount double precision NOT NULL, "type" varchar(50) NOT NULL, paid_timestamp timestamp, CONSTRAINT devolucion_pkey PRIMARY KEY (id) );
ALTER TABLE devolucion ADD CONSTRAINT devolucion_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);

CREATE TABLE captures (
    id bigserial NOT NULL,
    orden_id bigserial NOT NULL,
    amount double precision NOT NULL,
    "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    trackTraceCode text,
    trackTraceUrl text,
    carrier text,
    shipDate varchar(30),
    reason text,
    CONSTRAINT captures_pkey PRIMARY KEY (id)
);

ALTER TABLE captures ADD CONSTRAINT captures_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE devolucion_item ( id bigserial NOT NULL, devolucion_id bigserial NOT NULL, item_id bigserial NOT NULL, quantity integer NOT NULL, reference text NOT NULL, name text NOT NULL, CONSTRAINT devolucion_item_pkey PRIMARY KEY (id) );
ALTER TABLE devolucion_item ADD CONSTRAINT devolucion_item_devolucion_id_fkey FOREIGN KEY (devolucion_id) REFERENCES devolucion (id);
ALTER TABLE devolucion_item ADD CONSTRAINT devolucion_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES item (id);
CREATE TABLE devolucion_estatus ( id bigserial NOT NULL, devolucion_id bigserial NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), status varchar(50) NOT NULL, CONSTRAINT devolucion_estatus_pkey PRIMARY KEY (id) );
ALTER TABLE devolucion_estatus ADD CONSTRAINT devolucion_estatus_devolucion_id_fkey FOREIGN KEY (devolucion_id) REFERENCES devolucion (id);

CREATE TABLE orden_pago_operacion (
    id bigserial NOT NULL,
    orden_id bigserial NOT NULL,
    amount double precision NOT NULL,
    currency VARCHAR(10) NOT NULL,
    description text,
    external_operacion_id text NOT NULL,
    payment_description text NOT NULL,
    "type" VARCHAR(50) NOT NULL,
    CONSTRAINT rorden_pago_methods_pkey PRIMARY KEY (id)
);

ALTER TABLE orden_pago_operacion ADD CONSTRAINT orden_pago_tran_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE orden_pago_operacion_estatus ( id bigserial NOT NULL, orden_pago_operacion_id bigserial NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), status varchar(50) NOT NULL, CONSTRAINT orden_pago_estatus_pkey PRIMARY KEY (id) );
ALTER TABLE orden_pago_operacion_estatus ADD CONSTRAINT orden_pago_estatus_tran_payment_id_fkey FOREIGN KEY (orden_pago_operacion_id) REFERENCES orden_pago_operacion (id);

CREATE TABLE orden_pago_operacion_details (
    id bigserial NOT NULL,
    orden_pago_operacion_id bigserial NOT NULL,
    account_bic text,
    account_holder_name text,
    account_iban text,
    account_id text,
    external_operacion_id text NOT NULL,
    issuer_id text,
    recurring_flow text,
    recurring_id text,
    recurring_model text,
    "type" VARCHAR(50) NOT NULL,
    CONSTRAINT orden_pago_operacion_details_pkey PRIMARY KEY (id)
);

ALTER TABLE orden_pago_operacion_details ADD CONSTRAINT orden_pago_tran_det_id_fkey FOREIGN KEY (orden_pago_operacion_id) REFERENCES orden_pago_operacion (id);
ALTER TABLE orden_proyecto ALTER COLUMN customer_id TYPE varchar(40);
ALTER TABLE address DROP COLUMN street_address, DROP COLUMN street_address2;
ALTER TABLE address ADD COLUMN street_type VARCHAR(100), ADD COLUMN street_name VARCHAR(200), ADD COLUMN street_number INTEGER, ADD COLUMN block VARCHAR(20), ADD COLUMN floor INTEGER, ADD COLUMN door VARCHAR(20);
ALTER TABLE orden_proyecto RENAME COLUMN mobile_phone TO phone;
CREATE TABLE document ( id bigserial NOT NULL, orden_id bigserial NOT NULL, doc_number varchar(100) NOT NULL, doc_type varchar(100) NOT NULL, CONSTRAINT document_pkey PRIMARY KEY (id) );
ALTER TABLE document ADD CONSTRAINT document_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE item ADD COLUMN description text;
ALTER TABLE orden_proyecto DROP COLUMN national_id_number, DROP COLUMN orden_pago_fee;
ALTER TABLE captures ADD COLUMN invoice_id text, ADD COLUMN po_number text, ADD COLUMN invoice_url text, ADD COLUMN shipping_cost VARCHAR(20);
ALTER TABLE captures DROP COLUMN amount;
ALTER TABLE captures DROP COLUMN shipping_cost;
ALTER TABLE captures ADD COLUMN shipping_cost double precision;
ALTER TABLE orden_proyecto ADD COLUMN bnk_transferencia_iban_to_pay text;
ALTER TABLE orden_proyecto ADD COLUMN bnk_transferencia_reference text;
ALTER TABLE orden_proyecto ADD COLUMN debt_collecting_agency_date timestamp;
ALTER TABLE orden_proyecto ADD COLUMN agent_orden_id text;
CREATE TABLE late_payment ( id bigserial NOT NULL, orden_id bigserial NOT NULL, payment_overdue_date timestamp NOT NULL, accumulated_late_fee_amount double precision NOT NULL, timestamp_dr timestamp NOT NULL DEFAULT (now() at time zone 'utc'), CONSTRAINT late_payment_pkey PRIMARY KEY (id) );
ALTER TABLE late_payment ADD CONSTRAINT late_payment_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE TERMS_AND_CONDITIONS ( ID BIGINT NOT NULL, ACCEPTANCE_TIMESTAMP TIMESTAMP NOT NULL, CHANNEL CHARACTER VARYING(255) NOT NULL, AGENT_ID CHARACTER VARYING(255), VERSION_ID CHARACTER VARYING(255) NOT NULL, CUSTOMER_ID CHARACTER VARYING(255) NOT NULL, PRODUCT_ID CHARACTER VARYING(255) NOT NULL, ACCEPTED_TEXT CHARACTER VARYING(1000) NOT NULL, NOTIFICATION_ID CHARACTER VARYING(255), COUNTRY varchar(3), CONSTRAINT TERMS_AND_CONDITIONS_PKEY PRIMARY KEY (ID) );
ALTER TABLE item ALTER COLUMN image_url DROP NOT null;
ALTER TABLE item ALTER COLUMN tax_rate DROP NOT null;
ALTER TABLE item ALTER COLUMN total_amount DROP NOT null;
ALTER TABLE item ALTER COLUMN total_discount_amount DROP NOT null;
ALTER TABLE item ALTER COLUMN total_tax_amount DROP NOT null;ALTER TABLE orden_proyecto ADD COLUMN bnk_transferencia_bic text;
ALTER TABLE orden_proyecto ADD COLUMN bnk_transferencia_holder text;
CREATE TABLE cancellation ( id bigserial NOT NULL, orden_id bigserial NOT NULL, amount double precision NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), "type" VARCHAR(20), CONSTRAINT cancellation_pkey PRIMARY KEY (id) );
ALTER TABLE cancellation ADD CONSTRAINT cancellation_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE orden_pago_operacion_details ADD COLUMN invoice_url text;
ALTER TABLE orden_pago_operacion_details ADD COLUMN collecting_flow text;
ALTER TABLE orden_proyecto ADD COLUMN orden_name text;
ALTER TABLE orden_proyecto alter column PHONE drop not null;
ALTER TABLE devolucion ADD COLUMN subtype VARCHAR(10);
ALTER TABLE devolucion ALTER COLUMN subtype SET NOT NULL;DROP TABLE TERMS_AND_CONDITIONS;
CREATE TABLE TERMS_AND_CONDITIONS ( ID bigserial NOT NULL, ACCEPTANCE_TIMESTAMP TIMESTAMP NOT NULL, CHANNEL CHARACTER VARYING(255) NOT NULL, AGENT_ID CHARACTER VARYING(255), VERSION_ID CHARACTER VARYING(255) NOT NULL, CUSTOMER_ID CHARACTER VARYING(255) NOT NULL, PRODUCT_ID CHARACTER VARYING(255) NOT NULL, ACCEPTED_TEXT CHARACTER VARYING(1000) NOT NULL, NOTIFICATION_ID CHARACTER VARYING(255), COUNTRY varchar(3), orden_ID CHARACTER VARYING(255) NOT NULL, CONSTRAINT TERMS_AND_CONDITIONS_PKEY PRIMARY KEY (ID) );
ALTER TABLE orden_proyecto ADD COLUMN payment_due_date timestamp;
ALTER TABLE orden_proyecto ADD COLUMN total_amount double precision;
ALTER TABLE orden_proyecto 
ALTER COLUMN birth_date TYPE date USING birth_date::date;
CREATE UNIQUE INDEX IF NOT EXISTS orden_orden_id_idx ON orden_proyecto (orden_id);
ALTER TABLE address ALTER COLUMN street_number TYPE varchar(20) USING street_number::varchar;
CREATE TABLE capture_item ( id bigserial NOT NULL, capture_id bigserial NOT NULL, item_id bigserial NOT NULL, quantity integer NOT NULL, reference text NOT NULL, name text NOT NULL, CONSTRAINT capture_item_pkey PRIMARY KEY (id) );
ALTER TABLE capture_item ADD CONSTRAINT capture_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES item(id);
ALTER TABLE capture_item ADD CONSTRAINT capture_item_capture_id_fkey FOREIGN KEY (capture_id) REFERENCES captures(id);
ALTER TABLE cancellation ALTER COLUMN amount TYPE numeric USING amount::numeric;
ALTER TABLE captures ALTER COLUMN shipping_cost TYPE numeric USING shipping_cost::numeric;
ALTER TABLE item ALTER COLUMN tax_rate TYPE numeric USING tax_rate::numeric;
ALTER TABLE item ALTER COLUMN total_amount TYPE numeric USING total_amount::numeric;
ALTER TABLE item ALTER COLUMN total_discount_amount TYPE numeric USING total_discount_amount::numeric;
ALTER TABLE item ALTER COLUMN total_tax_amount TYPE numeric USING total_tax_amount::numeric;
ALTER TABLE item ALTER COLUMN unit_price TYPE numeric USING unit_price::numeric;
ALTER TABLE late_payment ALTER COLUMN accumulated_late_fee_amount TYPE numeric USING accumulated_late_fee_amount::numeric;
ALTER TABLE orden_proyecto ALTER COLUMN orden_tax_amount TYPE numeric USING orden_tax_amount::numeric;
ALTER TABLE orden_proyecto ALTER COLUMN orden_delivery_fee TYPE numeric USING orden_delivery_fee::numeric;
ALTER TABLE orden_proyecto ALTER COLUMN orden_total_amount TYPE numeric USING orden_total_amount::numeric;
ALTER TABLE orden_proyecto ALTER COLUMN total_amount TYPE numeric USING total_amount::numeric;
ALTER TABLE orden_pago_operacion ALTER COLUMN amount TYPE numeric USING amount::numeric;
ALTER TABLE devolucion ALTER COLUMN amount TYPE numeric USING amount::numeric;
ALTER TABLE orden_proyecto ADD COLUMN has_been_on_hold bool DEFAULT FALSE,ADD COLUMN on_hold_start_date TIMESTAMP;
ALTER TABLE orden_proyecto ADD COLUMN on_hold_end_date TIMESTAMP;

CREATE TABLE postponement (
    id bigserial NOT NULL,
    orden_id bigserial NOT NULL,	
    "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    previous_payment_due_date TIMESTAMP NOT NULL,
    new_payment_due_date TIMESTAMP NOT NULL,
    postponement_fee_amount numeric NOT NULL,
    external_operacion_id text NOT NULL,
    CONSTRAINT postponement_pkey PRIMARY KEY (id)
);

ALTER TABLE postponement ADD CONSTRAINT postponement_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE postponement_estatus ( id bigserial NOT NULL, postponement_id bigserial NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), status varchar(50) NOT NULL, CONSTRAINT postponement_estatus_pkey PRIMARY KEY (id) );
ALTER TABLE postponement_estatus ADD CONSTRAINT postponement_estatus_postponement_id_fkey FOREIGN KEY (postponement_id) REFERENCES postponement (id);
ALTER TABLE orden_proyecto_estatus ADD COLUMN timestamp_dr TIMESTAMP;
ALTER TABLE orden_pago_operacion_estatus ADD COLUMN timestamp_dr TIMESTAMP;
ALTER TABLE devolucion_estatus ADD COLUMN timestamp_dr TIMESTAMP;
ALTER TABLE postponement ADD COLUMN type VARCHAR(30) NOT NULL;
ALTER TABLE orden_proyecto ADD COLUMN type_engine VARCHAR(15) DEFAULT 'MSP';
ALTER TABLE orden_proyecto ADD COLUMN capture_id VARCHAR(255);
ALTER TABLE orden_proyecto ADD COLUMN collection_flow VARCHAR(255);
ALTER TABLE cancellation ADD COLUMN cancellation_id VARCHAR(150);
ALTER TABLE orden_proyecto ADD COLUMN expiration_date timestamp;
ALTER TABLE orden_proyecto ADD COLUMN process_id VARCHAR(250);
DROP TABLE IF EXISTS orden_pagos;
DROP TABLE IF EXISTS orden_pago_estatus;
DROP TABLE IF EXISTS payment_estatus;
CREATE TABLE payment_estatus ( "id" INTEGER PRIMARY KEY, "description" VARCHAR(50) NOT NULL );
CREATE TABLE orden_pagos ( "id" BIGSERIAL PRIMARY KEY, "orden_id" UUID NOT NULL, "amount" DECIMAL NOT NULL, "currency" VARCHAR(3) NOT NULL, "created_at" TIMESTAMP NOT NULL, "update_at" TIMESTAMP NOT NULL, "payment_to" VARCHAR(50) NOT NULL, "payment_type" VARCHAR(50) NOT NULL, "payment_reference" VARCHAR(24) );
CREATE TABLE orden_pago_estatus ( "payment_id" BIGSERIAL NOT NULL, "status_id" INTEGER NOT NULL, "created_at" TIMESTAMP NOT NULL, FOREIGN KEY (payment_id) REFERENCES orden_pagos (id), FOREIGN KEY (status_id) REFERENCES payment_estatus (id), PRIMARY KEY (payment_id, status_id) );
ALTER TABLE orden_pagos DROP COLUMN "orden_id";
ALTER TABLE orden_pagos ADD COLUMN "orden_id" BIGSERIAL;
ALTER TABLE orden_pagos ADD CONSTRAINT orden_pagos_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE orden_pagos ALTER COLUMN "id" DROP DEFAULT;
ALTER TABLE orden_pagos ALTER COLUMN "amount" TYPE DECIMAL;-- ZIN-423
CREATE TABLE item_estatus ( id bigserial NOT NULL, item_estatus_type int2 NOT NULL, since timestamp NOT NULL, item_id bigint NOT NULL, CONSTRAINT item_estatus_pk PRIMARY KEY (id), CONSTRAINT item_estatus_item_fk FOREIGN KEY (item_id) REFERENCES item (id) );
ALTER TABLE item ADD discriminator varchar(3) NOT NULL DEFAULT 'MSP';
ALTER TABLE item ALTER COLUMN quantity DROP NOT NULL;
CREATE TABLE communications ( id bigserial NOT NULL, orden_id bigint NOT NULL, operation_id VARCHAR(100) NOT NULL, operation_code VARCHAR(20) NOT NULL, "timestamp" timestamp NOT NULL, CONSTRAINT communication_pk PRIMARY KEY (id), CONSTRAINT communication_orden_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id) );
ALTER TABLE orden_proyecto ADD COLUMN is_pos_validated boolean;--ZIN-440
CREATE TABLE cancellation_item ( id bigserial NOT NULL, cancellation_id bigint NOT NULL, item_id bigint NOT NULL, cancel_at timestamp NOT NULL, CONSTRAINT cancellation_item_pk PRIMARY KEY (id), CONSTRAINT cancellation_item_item_fk FOREIGN KEY (item_id) REFERENCES item (id), CONSTRAINT cancellation_item_cancellation_fk FOREIGN KEY (cancellation_id) REFERENCES cancellation (id) );
CREATE TABLE cancellation_estatus ( id bigserial NOT NULL, cancellation_id bigint NOT NULL, status varchar(50) NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), CONSTRAINT cancellation_estatus_pk PRIMARY KEY (id), CONSTRAINT cancellation_estatus_cancellation_fk FOREIGN KEY (cancellation_id) REFERENCES cancellation (id) );
ALTER TABLE item_estatus ALTER COLUMN item_estatus_type TYPE INT USING item_estatus_type::INTEGER;
ALTER TABLE item drop column discriminator;
ALTER TABLE item ALTER COLUMN quantity SET NOT NULL;
ALTER TABLE orden_proyecto ADD COLUMN payment_current_dead_line_date timestamp;
CREATE TABLE orden_pago_estatus_tmp ( id bigserial NOT NULL, payment_id bigint NOT NULL, status_id int4 NOT NULL, created_at timestamp NOT NULL, CONSTRAINT orden_pago_estatus_pk PRIMARY KEY (id), CONSTRAINT orden_pago_estatus_payment_fk FOREIGN KEY (payment_id) REFERENCES orden_pagos (id), CONSTRAINT ordre_payment_estatus_estatus_fk FOREIGN KEY (status_id) REFERENCES payment_estatus (id) );
DROP TABLE orden_pago_estatus;
ALTER TABLE orden_pago_estatus_tmp RENAME TO orden_pago_estatus;
ALTER SEQUENCE orden_pago_estatus_tmp_id_seq RENAME TO orden_pago_estatus_id_seq;
ALTER TABLE orden_pago_estatus ADD COLUMN "status" varchar(20);
DROP TABLE IF EXISTS payment_estatus;
ALTER TABLE cancellation_item ADD COLUMN quantity integer NOT NULL DEFAULT 1;
ALTER TABLE captures ADD COLUMN amount NUMERIC;
ALTER TABLE captures ALTER COLUMN amount SET NOT NULL;
ALTER TABLE captures ADD COLUMN type VARCHAR(10);
ALTER TABLE captures ALTER COLUMN type SET NOT NULL;
ALTER TABLE captures ADD COLUMN capture_id VARCHAR(150);
ALTER TABLE orden_proyecto DROP COLUMN capture_id;
ALTER TABLE item_estatus ALTER COLUMN "item_estatus_type" TYPE varchar(20);
ALTER TABLE orden_proyecto ADD COLUMN unverified_customer_id BIGINT;
ALTER TABLE orden_proyecto ALTER COLUMN email DROP NOT NULL;
ALTER TABLE orden_proyecto ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE orden_proyecto ALTER COLUMN last_name DROP NOT NULL;
ALTER TABLE terms_and_conditions ADD COLUMN unverified_customer_id BIGINT;
ALTER TABLE terms_and_conditions ALTER COLUMN customer_id DROP NOT NULL;
ALTER TABLE address ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE address ALTER COLUMN last_name DROP NOT NULL;
ALTER TABLE captures ADD COLUMN devolucioned_amount NUMERIC;
CREATE TABLE installment ( id bigserial NOT NULL, orden_id bigserial NOT NULL, installment_number integer NOT NULL, active boolean NOT NULL, bnk_transferencia_reference text NOT NULL, amount numeric NOT NULL, fee numeric NOT NULL, pending numeric NOT NULL, paid numeric NOT NULL, created_timestamp timestamp NOT NULL, due_date timestamp NOT NULL, CONSTRAINT installment_pkey PRIMARY KEY (id) );
ALTER TABLE installment ADD CONSTRAINT installment_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
CREATE TABLE installment_estatus ( id bigserial NOT NULL, installment_id bigserial NOT NULL, status varchar(50) NOT NULL, "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'), timestamp_dr TIMESTAMP, CONSTRAINT installment_estatus_pkey PRIMARY KEY (id) );
ALTER TABLE installment_estatus ADD CONSTRAINT installment_estatus_installment_id_fkey FOREIGN KEY (installment_id) REFERENCES installment (id);
ALTER TABLE orden_proyecto ADD COLUMN validated_phone VARCHAR(20);

CREATE TABLE IF NOT EXISTS activity_timeline (
    id bigserial NOT NULL,
    orden_id bigint NOT NULL,
    activity varchar(50) NOT NULL,
    amount numeric NOT NULL,
    currency varchar(3) NOT NULL,
    "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    orden_estatus varchar(50) NOT NULL,
    CONSTRAINT activity_timeline_pk PRIMARY KEY (id),
    CONSTRAINT activity_timeline_orden_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id)
);

CREATE TABLE orden_plugin ( orden_id bigserial NOT NULL, plugin_name varchar(100), plugin_version varchar(100), ecommerce_name varchar(100), ecommerce_version varchar(100), CONSTRAINT orden_plugin_pk PRIMARY KEY (orden_id), CONSTRAINT orden_plugin_orden_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id) );
ALTER TABLE orden_proyecto ALTER COLUMN phone TYPE VARCHAR(30);
ALTER TABLE orden_proyecto ADD CONSTRAINT uq_merchant_orden_id_merchant_id UNIQUE(merchant_orden_id, merchant_id);
ALTER TABLE installment ALTER COLUMN due_date DROP NOT NULL;
ALTER TABLE installment ALTER COLUMN bnk_transferencia_reference DROP NOT NULL;
ALTER TABLE orden_pagos ADD COLUMN installment_number integer;
ALTER TABLE late_payment ADD COLUMN installment_number integer;
ALTER TABLE orden_proyecto ADD COLUMN trusted_customer boolean;
ALTER TABLE devolucion ALTER COLUMN subtype TYPE varchar(15);
ALTER TABLE devolucion ADD COLUMN devolucion_real_id bigint;
ALTER TABLE devolucion ADD CONSTRAINT devolucion_devolucion_id_fkey FOREIGN KEY (devolucion_real_id) REFERENCES devolucion (id);
ALTER TABLE orden_pagos ADD ft_number varchar(50) null;
ALTER TABLE orden_pagos RENAME COLUMN payment_reference TO core_payment_reference;
ALTER TABLE orden_pagos ADD payment_reference varchar(150) null;
ALTER TABLE installment ADD COLUMN due_date_in_minutes BIGINT;
ALTER TABLE orden_proyecto ADD COLUMN merchant_channel_id VARCHAR(300);

CREATE TABLE IF NOT EXISTS on_hold (
    id bigserial NOT NULL,
    orden_id bigint NOT NULL,
    holding_reason_id int4 NOT NULL,
    days_held int4 not NULL,
    created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    on_hold_start_date timestamp NOT NULL,
    on_hold_end_date timestamp NOT NULL,
    CONSTRAINT on_hold_pkey PRIMARY KEY (id),
    CONSTRAINT orden_proyecto_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto(id)
);
ALTER TABLE on_hold ALTER COLUMN days_held DROP NOT NULL;

CREATE TABLE IF NOT EXISTS holding_reason (
    id                  serial NOT NULL,
    country             varchar(2) NOT NULL,
    days_to_hold        int4 not NULL,
    hold_requestor      varchar(8) NOT NULL,
    reason_description  varchar(500) NULL,
    created_at          timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at          timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    enabled             BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT holding_reason_pkey PRIMARY KEY (id)
);

ALTER TABLE orden_pago_estatus ADD reason varchar(30) NULL;
ALTER TABLE devolucion ADD COLUMN operacion_id bigint;
CREATE SEQUENCE operacion_id_seq INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE;
ALTER TABLE on_hold ADD CONSTRAINT on_hold_holding_reason_id_fkey FOREIGN KEY (holding_reason_id) REFERENCES holding_reason (id);
CREATE TABLE IF NOT EXISTS orden_expiration ( id bigserial NOT NULL, orden_id bigserial NOT NULL, amount_expired numeric NOT NULL, expiration_date TIMESTAMP NOT NULL, created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()), updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()), CONSTRAINT orden_expiration_pkey PRIMARY KEY (id) );
ALTER TABLE orden_expiration ADD CONSTRAINT orden_expiration_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE orden_proyecto DROP COLUMN on_hold_start_date, DROP COLUMN on_hold_end_date;
ALTER TABLE on_hold ALTER COLUMN on_hold_end_date drop not null;
ALTER TABLE installment ADD COLUMN payment_id bigint;
ALTER TABLE orden_proyecto ADD COLUMN close_reason text;
ALTER TABLE orden_proyecto ADD COLUMN close_reason_date timestamp;
ALTER TABLE on_hold RENAME COLUMN days_held TO minutes_held;ALTER TABLE address ALTER COLUMN region TYPE VARCHAR(60);
ALTER TABLE orden_expiration ADD COLUMN type VARCHAR(10) DEFAULT 'COMPLETED';
ALTER TABLE orden_expiration ALTER COLUMN type SET NOT NULL;
ALTER TABLE devolucion ADD COLUMN reason varchar(30);
ALTER TABLE devolucion ALTER COLUMN reason SET NOT NULL;
ALTER TABLE late_payment ADD COLUMN late_fee_amount NUMERIC;
ALTER TABLE postponement ALTER COLUMN external_operacion_id DROP NOT NULL;
CREATE TABLE installment_payments ( id bigserial NOT NULL, installment_id bigint NOT NULL, payment_id bigint NOT NULL, CONSTRAINT installment_payments_pkey PRIMARY KEY (id), CONSTRAINT installment_fk FOREIGN KEY (installment_id) REFERENCES installment(id), CONSTRAINT orden_pagos_fk FOREIGN KEY (payment_id) REFERENCES orden_pagos(id) );
ALTER TABLE activity_timeline ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE activity_timeline ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE address ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE address ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation_item ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation_item ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE cancellation_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE captures ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE captures ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE capture_item ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE capture_item ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE communications ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE communications ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE document ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE document ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE installment ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE installment ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE installment_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE installment_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE item ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE item ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE item_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE item_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_proyecto ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_proyecto ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE late_payment ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE late_payment ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion_details ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion_details ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_pago_operacion_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_plugin ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_plugin ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_proyecto_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_proyecto_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE postponement ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE postponement ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE postponement_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE postponement_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion_item ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion_item ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion_estatus ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE devolucion_estatus ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE terms_and_conditions ADD created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE terms_and_conditions ADD updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE installment ADD COLUMN current_amount numeric;
ALTER TABLE installment ALTER COLUMN current_amount SET NOT NULL;
ALTER TABLE address ADD COLUMN street_address VARCHAR(500), ADD COLUMN street_address_2 VARCHAR(500);
ALTER TABLE orden_proyecto DROP CONSTRAINT uq_merchant_orden_id_merchant_id;

CREATE TABLE orden_cards_operacions
(
    "id"                      BIGSERIAL   NOT NULL,
    "orden_id"                INT8        NOT NULL,
    "payment_id"              INT8        NOT NULL,
    "card_operacion_id"     INT8        NOT NULL,
    "card_operacion_estatus" VARCHAR(21) NOT NULL,
    "created_at"              TIMESTAMP   NOT NULL DEFAULT (now() at time zone 'utc'),
    "updated_at"              TIMESTAMP   NOT NULL DEFAULT (now() at time zone 'utc'),
    CONSTRAINT orden_cards_operacions_pk PRIMARY KEY (id),
    CONSTRAINT orden_proyecto_cards_operacions_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id)
);

ALTER TABLE orden_pagos ADD card_operacion_id INT8;
ALTER TABLE orden_proyecto ADD COLUMN is_captured boolean NOT NULL DEFAULT false;
ALTER TABLE orden_cards_operacions ADD success_redirect_url text NOT NULL;
ALTER TABLE orden_cards_operacions ADD fail_redirect_url text NOT NULL;
ALTER TABLE orden_cards_operacions ADD cancel_redirect_url text NOT NULL;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS current_estatus VARCHAR(20);
ALTER TABLE orden_proyecto ALTER COLUMN current_estatus SET NOT NULL;
ALTER TABLE activity_timeline ADD COLUMN variable_data VARCHAR(300);
ALTER TABLE orden_proyecto alter column unverified_customer_id type char USING unverified_customer_id::char;
ALTER TABLE terms_and_conditions alter column unverified_customer_id type char USING unverified_customer_id::char;
ALTER TABLE orden_proyecto alter column unverified_customer_id type uuid USING unverified_customer_id::uuid;
ALTER TABLE terms_and_conditions alter column unverified_customer_id type uuid USING unverified_customer_id::uuid;
ALTER TABLE orden_pago_estatus ALTER COLUMN reason TYPE varchar(40);
ALTER TABLE devolucion DROP COLUMN operacion_id;
DROP SEQUENCE IF EXISTS operacion_id_seq;
ALTER TABLE cancellation ADD COLUMN IF NOT EXISTS paid_timestamp timestamp, ADD COLUMN IF NOT EXISTS subtype VARCHAR(15), ADD COLUMN IF NOT EXISTS cancellation_real_id bigint, ADD COLUMN IF NOT EXISTS operacion_id bigint, ADD COLUMN IF NOT EXISTS reason VARCHAR(30);

CREATE TABLE IF NOT EXISTS orden_operacion_group (
    id bigserial NOT NULL,
    operacion_group_id uuid NOT NULL,
    partner_url varchar(250) NOT NULL,
    reference_id uuid NOT NULL, 
    operacion_channel varchar(10) NOT NULL,
    operacion_group_number varchar(100) NOT NULL,
    operacion_group_amount numeric NOT NULL,
    merchant_id varchar(50) NOT NULL,
    success_url varchar(1024),
    failure_url varchar(1024),
    return_url varchar(1024),
    pending_url varchar(1024),
    call_back_url varchar(1024),
    down_payment_amount numeric,
    created_at timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    CONSTRAINT operacion_group_id_pkey PRIMARY KEY (id)
);


CREATE UNIQUE INDEX IF NOT EXISTS operacion_group_id_idx ON orden_operacion_group (operacion_group_id);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS operacion_group_id bigint;
ALTER TABLE orden_proyecto ADD CONSTRAINT orden_tran_group_id_fkey FOREIGN KEY (operacion_group_id) REFERENCES orden_operacion_group (id);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS description varchar(256);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS program_plan_id varchar(36);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS plan_id varchar(36);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS parent_merchant_orden_id varchar(200);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS merchant_customer_id varchar(50);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS trade_in_amount numeric;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS discount_amount numeric;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS other_amount numeric;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS orden_total_principal_amount NUMERIC, ADD COLUMN IF NOT EXISTS orden_total_interest_amount NUMERIC DEFAULT 0, ADD COLUMN IF NOT EXISTS related_orden_id UUID, ADD COLUMN IF NOT EXISTS total_principal_amount NUMERIC, ADD COLUMN IF NOT EXISTS total_interest_amount NUMERIC DEFAULT 0;
ALTER TABLE orden_proyecto ADD CONSTRAINT orden_proyecto_orden_id_fkey FOREIGN KEY (related_orden_id) REFERENCES orden_proyecto (orden_id);


CREATE TABLE IF NOT EXISTS rate_payment (
    id BIGSERIAL NOT NULL,
    orden_id BIGSERIAL NOT NULL,
    accumulated_late_rate_amount NUMERIC NOT NULL,
    installment_number INTEGER NOT NULL,
    late_rate_amount NUMERIC NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    type_rate VARCHAR(20) NOT NULL,
    CONSTRAINT rate_payment_id_pkey PRIMARY KEY (id)
);

ALTER TABLE rate_payment ADD CONSTRAINT rate_payment_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE installment ADD COLUMN principal_amount NUMERIC, ADD COLUMN interest_amount NUMERIC DEFAULT 0, ADD COLUMN outstanding_principal NUMERIC, ADD COLUMN plan_id UUID, ADD COLUMN rate NUMERIC DEFAULT 0;

CREATE TABLE IF NOT EXISTS expiration_estatus (
    id bigserial NOT NULL,
    expiration_id bigint NOT NULL,
    status varchar(50) NOT NULL,
    "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    timestamp_dr timestamp,
    created_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at timestamp NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT expiration_estatus_pk PRIMARY KEY (id),
    CONSTRAINT expiration_estatus_expiration_fk FOREIGN KEY (expiration_id) REFERENCES orden_expiration (id)
);

ALTER TABLE orden_expiration ADD COLUMN IF NOT EXISTS paid_timestamp timestamp, ADD COLUMN IF NOT EXISTS subtype VARCHAR(15), ADD COLUMN IF NOT EXISTS expiration_real_id bigint;
ALTER TABLE orden_cards_operacions ALTER COLUMN payment_id DROP NOT NULL;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS interest_rate NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS principal_paid NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS interest_paid NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS fee_paid NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS rate_paid NUMERIC;

CREATE TABLE IF NOT EXISTS price_change (
    id BIGSERIAL NOT NULL,
    orden_id bigint NOT NULL,
    amount NUMERIC NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    subtype VARCHAR(15),
    price_change_real_id bigint,
    CONSTRAINT price_change_id_pkey PRIMARY KEY (id)
);

ALTER TABLE price_change ADD CONSTRAINT orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE price_change ADD CONSTRAINT price_change_real_id_fkey FOREIGN KEY (price_change_real_id) REFERENCES price_change (id);
CREATE TABLE IF NOT EXISTS price_change_estatus ( id BIGSERIAL NOT NULL, price_change_id bigint NOT NULL, status VARCHAR(50), created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'), updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'), CONSTRAINT price_change_estatus_id_pkey PRIMARY KEY (id) );
ALTER TABLE price_change_estatus ADD CONSTRAINT price_change_id_fkey FOREIGN KEY (price_change_id) REFERENCES price_change (id);
ALTER TABLE cancellation ADD COLUMN IF NOT EXISTS operacion_group_cancel_id UUID;
ALTER TABLE price_change ALTER COLUMN subtype TYPE varchar(20);
ALTER TABLE price_change ADD COLUMN IF NOT EXISTS operacion_group_price_change_id uuid;
CREATE TABLE IF NOT EXISTS clawback ( "id" BIGSERIAL PRIMARY KEY, "orden_id" UUID NOT NULL, "amount" DECIMAL NOT NULL, "created_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()), "updated_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()) );
CREATE TABLE IF NOT EXISTS clawback_estatus ( "id" BIGSERIAL PRIMARY KEY, "clawback_id" BIGINT NOT NULL, "status" VARCHAR(50) NOT NULL, "created_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()), "updated_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()), constraint clawback_clawback_estatus_id_fkey FOREIGN KEY (clawback_id) references clawback (id) );
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS provider VARCHAR(50);
ALTER TABLE clawback DROP COLUMN orden_id;
ALTER TABLE clawback ADD COLUMN orden_id bigint;
ALTER TABLE devolucion ADD COLUMN operacion_group_devolucion_id UUID;
ALTER TABLE orden_pagos ADD operacion_id int8;
ALTER TABLE clawback ADD COLUMN IF NOT EXISTS operacion_group_clawback_id UUID;
ALTER TABLE orden_operacion_group ADD COLUMN payment_reference varchar(50);
ALTER TABLE devolucion ADD COLUMN IF NOT EXISTS current_estatus VARCHAR(20);
ALTER TABLE devolucion ALTER COLUMN current_estatus SET NOT NULL;
ALTER TABLE orden_proyecto ALTER COLUMN title TYPE varchar(25);
ALTER TABLE terms_and_conditions ADD COLUMN terms_document_id text;
ALTER TABLE terms_and_conditions ADD COLUMN privacy_document_id text;ALTER TABLE orden_proyecto ALTER COLUMN channel TYPE varchar(150);
ALTER TABLE orden_operacion_group ALTER COLUMN operacion_channel TYPE varchar(150);
ALTER TABLE clawback ADD CONSTRAINT clawback_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE clawback ADD COLUMN IF NOT EXISTS clawback_id BIGINT;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS nominal_interest numeric;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS orden_total_principal_interest_amount numeric;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS total_principal_interest_amount numeric;
ALTER TABLE orden_proyecto RENAME COLUMN orden_total_principal_interest_amount TO orden_total_customer_debt_amount;
ALTER TABLE orden_proyecto RENAME COLUMN total_principal_interest_amount TO total_customer_debt_amount;
ALTER TABLE late_payment ADD COLUMN IF NOT EXISTS waived BOOLEAN;
ALTER TABLE orden_proyecto add column if not exists orden_mdr numeric;
ALTER TABLE address alter column postal_code drop not null;
CREATE TABLE IF NOT EXISTS cancellation_request ( id BIGSERIAL NOT NULL, orden_id bigint NOT NULL, reason varchar(30) NOT NULL, created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'), updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'), CONSTRAINT cancellation_request_id_pkey PRIMARY KEY (id) );
ALTER TABLE cancellation_request ADD CONSTRAINT cancellation_request_orden_id_fkey FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id);
ALTER TABLE orden_operacion_group ALTER COLUMN reference_id TYPE varchar(150);
ALTER TABLE item ALTER COLUMN "name" TYPE varchar(200);
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS installment_url TEXT;
ALTER TABLE devolucion ALTER COLUMN subtype TYPE varchar(20) USING subtype::varchar;ALTER TABLE captures ADD COLUMN IF NOT EXISTS billing_cycle INTEGER;
ALTER TABLE captures ADD COLUMN IF NOT EXISTS invoice_settlement_date TIMESTAMP;
CREATE TABLE group_payment_reference ( "id" BIGSERIAL NOT NULL, "group_payment_reference" VARCHAR(50), "created_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()), "updated_at" TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()), CONSTRAINT group_payment_reference_pk PRIMARY KEY (id) );
ALTER TABLE orden_pagos ADD COLUMN "group_payment_reference_id" BIGINT, ADD CONSTRAINT group_payment_reference_id_fkey FOREIGN KEY ("group_payment_reference_id") REFERENCES group_payment_reference(id);

CREATE TABLE partial_approval (
    "id" BIGSERIAL NOT NULL,
    "orden_id" BIGINT NOT NULL,
    "amount" NUMERIC NOT NULL,
    "currency" varchar(10) NOT NULL,
    "current_estatus" varchar(50) NOT NULL,
    "created_at"               TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    "updated_at"               TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT partial_approval_id_pkey PRIMARY KEY (id),
    CONSTRAINT partial_approval_orden_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id)
);

CREATE TABLE partial_approval_estatus (
    "id" BIGSERIAL NOT NULL,
    "partial_approval_id" BIGINT NOT NULL,
    "status" varchar(50) NOT NULL,
    "created_at"               TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    "updated_at"               TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT partial_approval_estatus_id_pkey PRIMARY KEY (id),
    CONSTRAINT partial_approval_estatus_partial_approval_fk FOREIGN KEY (partial_approval_id) REFERENCES partial_approval (id)
);

ALTER TABLE orden_operacion_group alter COLUMN payment_reference TYPE int8 USING payment_reference::int8, ADD CONSTRAINT group_payment_reference_id_fkey FOREIGN KEY ("payment_reference") REFERENCES group_payment_reference(id);
ALTER TABLE orden_pagos DROP COLUMN IF EXISTS group_payment_reference_id;
ALTER TABLE orden_proyecto ALTER COLUMN user_ip_address TYPE VARCHAR(39);

CREATE TABLE IF NOT EXISTS flexible_trade_in (
    id BIGSERIAL NOT NULL,
    orden_id BIGINT NOT NULL,
    currency VARCHAR(3),
    amount NUMERIC,
    waived_amount NUMERIC,
    description VARCHAR(200),
    compensation_orden_id BIGINT,
    created_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    reason VARCHAR(200),
    CONSTRAINT flexible_trade_in_pk PRIMARY KEY (id),
    CONSTRAINT flexible_trade_in_orden_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id),
    CONSTRAINT flexible_trade_in_compensation_orden_fk FOREIGN KEY (compensation_orden_id) REFERENCES flexible_trade_in (id)
);

CREATE TABLE flexible_trade_in_estatus (
    id BIGSERIAL NOT NULL,
    flexible_trade_in_id BIGINT NOT NULL,
    status varchar(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT flexible_trade_in_estatus_id_pkey PRIMARY KEY (id),
    CONSTRAINT flexible_trade_in_estatus_flexible_trade_in_fk FOREIGN KEY (flexible_trade_in_id) REFERENCES flexible_trade_in (id)
);

ALTER TABLE flexible_trade_in ADD COLUMN current_estatus varchar(50) NOT NULL;
ALTER TABLE flexible_trade_in_estatus ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now());
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS down_payment_amount numeric;
ALTER TABLE orden_proyecto ADD COLUMN irr NUMERIC;ALTER TABLE installment ADD COLUMN interest_irr_amount NUMERIC;
ALTER TABLE captures ADD COLUMN IF NOT EXISTS activation_date TIMESTAMP;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS current_estatus VARCHAR(20);
ALTER TABLE installment ALTER COLUMN current_estatus SET NOT NULL;

CREATE TABLE campaigns (
    id bigserial not null,
    operacion_group_id bigserial not null,
    event_type varchar(20) not null,
    issuer_installment_id varchar(50) not null,
    trade_in_value numeric not null,
    loan_balance numeric,
    billing_month int2,
    created_at timestamp not null default now(),
    created_by varchar(100) not null default 'system',
    updated_at timestamp not null default now(),
    updated_by varchar(100) not null default 'system',
    constraint campaigns_pk primary key (id),
    constraint campaigns_operacion_group_fk foreign key (operacion_group_id) references orden_operacion_group(id)
);

CREATE TABLE campaigns_crm_details (
    id bigserial not null,
    device_image_url text not null,
    lob text not null,
    description text not null,
    campaign_id bigserial not null,
    created_at timestamp not null default now(),
    created_by varchar(100) not null default 'system',
    updated_at timestamp not null default now(),
    updated_by varchar(100) not null default 'system',
    constraint campaigns_crm_details_pk primary key (id),
    constraint crm_details_campaigns_fk foreign key (campaign_id) references campaigns(id)
);

CREATE TABLE campaigns_grv_data (
    id bigserial not null,
    amount numeric not null,
    percentage numeric not null,
    start_date timestamp not null,
    end_date timestamp not null,
    guaranteed_upgrade_date timestamp not null,
    campaign_id bigserial not null,
    created_at timestamp not null default now(),
    created_by varchar(100) not null default 'system',
    updated_at timestamp not null default now(),
    updated_by varchar(100) not null default 'system',
    constraint campaigns_grv_data_pk primary key (id),
    constraint grv_data_campaigns_fk foreign key (campaign_id) references campaigns(id)
);
ALTER TABLE orden_proyecto ADD COLUMN global_interest_rate NUMERIC;
ALTER TABLE orden_proyecto ADD COLUMN global_irr NUMERIC;ALTER TABLE captures ADD COLUMN IF NOT EXISTS current_estatus VARCHAR(20);

CREATE TABLE IF NOT EXISTS capture_estatus (
    id BIGSERIAL NOT NULL,
    capture_id bigint NOT NULL,
    status VARCHAR(50) NOT NULL,
    "timestamp" timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    CONSTRAINT capture_estatus_id_pkey PRIMARY KEY (id),
    CONSTRAINT capture_estatus_captures_fk FOREIGN KEY (capture_id) REFERENCES captures (id)
);

CREATE TABLE IF NOT EXISTS orden_proyecto_detail (
    id BIGSERIAL NOT NULL PRIMARY KEY,
    orden_id BIGINT NOT NULL,
    customer_id UUID NOT NULL,
    is_dunning_process_active BOOLEAN NOT NULL DEFAULT false,
    is_dunning_process_active_at TIMESTAMP,
    is_handed_over BOOLEAN NOT NULL DEFAULT false,
    is_handed_over_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id)
);

ALTER TABLE campaigns ALTER COLUMN trade_in_value DROP NOT NULL;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS is_handed_over BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE orden_proyecto_detail ADD CONSTRAINT unique_orden_proyecto_detail_orden_id UNIQUE(orden_id);
ALTER TABLE orden_proyecto_detail DROP COLUMN IF EXISTS customer_id;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS interest_number_code INTEGER;

CREATE TABLE IF NOT EXISTS orden_proyecto_sign (
  id BIGSERIAL NOT NULL,
  orden_id BIGINT NOT NULL,
  action_id VARCHAR(45) NOT NULL,
  operacion_id VARCHAR(50),
  customer_id VARCHAR NOT NULL,
  sign_url VARCHAR(255),
  status_sign VARCHAR(255),
  status_id VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
  created_by VARCHAR(255) NOT NULL,
  updated_by VARCHAR(255) NOT NULL,
  CONSTRAINT orden_proyecto_sign_pk PRIMARY KEY (id),
  CONSTRAINT orden_proyecto_sign_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (id)
);


ALTER TABLE orden_proyecto_sign ADD COLUMN IF NOT EXISTS document_contract_id VARCHAR(300);alter table orden_proyecto_sign add column IF not EXISTS identification_method VARCHAR(50);ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS co_owner_id VARCHAR(40);ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS sdd_dunning_process_due_date TIMESTAMP;ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS delay_reason_code VARCHAR(30);
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS is_activation_delayed BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE captures DROP COLUMN invoice_settlement_date;
ALTER TABLE captures ADD COLUMN IF NOT EXISTS invoice_settlement_day INTEGER DEFAULT 1;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS is_activation_resumed BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE orden_proyecto ADD COLUMN IF NOT EXISTS pending_payment_operacion_id UUID;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS is_terminated BOOLEAN NOT NULL DEFAULT FALSE;ALTER TABLE holding_reason
ALTER COLUMN hold_requestor TYPE VARCHAR(50),
ALTER COLUMN hold_requestor SET NOT NULL;

ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS commission_fix NUMERIC;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS total_commission_amount NUMERIC;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS orden_total_commission_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS commission_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS commission_paid NUMERIC;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS total_adjustment_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS adjustment_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS adjustment_paid NUMERIC;

CREATE TABLE IF NOT EXISTS billing_cycle_change (
    id bigserial NOT NULL,
    orden_id UUID NOT NULL,
    billing_cycle_change_date timestamp NOT NULL DEFAULT (now() at time zone 'utc'),
    created_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    updated_at TIMESTAMP NOT NULL DEFAULT (now() at time zone 'utc'),
    CONSTRAINT billing_cycle_change_pk PRIMARY KEY (id),
    CONSTRAINT billing_cycle_change_fk FOREIGN KEY (orden_id) REFERENCES orden_proyecto (orden_id)
);

ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS downpayment BOOLEAN DEFAULT FALSE;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS orden_total_adjustment_commission_amount NUMERIC;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS total_adjustment_commission_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS adjustment_commission_amount NUMERIC;
ALTER TABLE installment ADD COLUMN IF NOT EXISTS adjustment_commission_paid NUMERIC;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS is_final_notice BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE activity_timeline ADD COLUMN IF NOT EXISTS provider VARCHAR(50);
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS is_ever_handed_over BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS store_number bigint;
ALTER TABLE orden_proyecto_detail DROP COLUMN store_number;
ALTER TABLE orden_proyecto_detail ADD COLUMN IF NOT EXISTS store_number varchar(25);
ALTER TABLE CAPTURE_ITEM ADD COLUMN IF NOT EXISTS amount NUMERIC NOT NULL DEFAULT 0;
ALTER TABLE devolucion_ITEM ADD COLUMN IF NOT EXISTS amount NUMERIC NOT NULL DEFAULT 0;