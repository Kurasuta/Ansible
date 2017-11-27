SET search_path TO public;
DROP TABLE IF EXISTS byte_histogram, magic, peyd, sample_has_peyd, path, sample, ioc, sample_has_heuristic_ioc, debug_directory, section_name, section, resource_type_pair, resource_name_pair, resource_language_pair, resource, guid, export_name, export_symbol_name, export_symbol, import, dll_name, import_namem, task_consumer, task, sample_function CASCADE;

CREATE TABLE byte_histogram (
    id serial PRIMARY KEY,
    byte_00 int, byte_01 int, byte_02 int, byte_03 int, byte_04 int, byte_05 int, byte_06 int, byte_07 int, byte_08 int, byte_09 int, byte_0a int, byte_0b int, byte_0c int, byte_0d int, byte_0e int, byte_0f int, byte_10 int, byte_11 int, byte_12 int, byte_13 int, byte_14 int, byte_15 int, byte_16 int, byte_17 int, byte_18 int, byte_19 int, byte_1a int, byte_1b int, byte_1c int, byte_1d int, byte_1e int, byte_1f int, byte_20 int, byte_21 int, byte_22 int, byte_23 int, byte_24 int, byte_25 int, byte_26 int, byte_27 int, byte_28 int, byte_29 int, byte_2a int, byte_2b int, byte_2c int, byte_2d int, byte_2e int, byte_2f int, byte_30 int, byte_31 int, byte_32 int, byte_33 int, byte_34 int, byte_35 int, byte_36 int, byte_37 int, byte_38 int, byte_39 int, byte_3a int, byte_3b int, byte_3c int, byte_3d int, byte_3e int, byte_3f int, byte_40 int, byte_41 int, byte_42 int, byte_43 int, byte_44 int, byte_45 int, byte_46 int, byte_47 int, byte_48 int, byte_49 int, byte_4a int, byte_4b int, byte_4c int, byte_4d int, byte_4e int, byte_4f int, byte_50 int, byte_51 int, byte_52 int, byte_53 int, byte_54 int, byte_55 int, byte_56 int, byte_57 int, byte_58 int, byte_59 int, byte_5a int, byte_5b int, byte_5c int, byte_5d int, byte_5e int, byte_5f int, byte_60 int, byte_61 int, byte_62 int, byte_63 int, byte_64 int, byte_65 int, byte_66 int, byte_67 int, byte_68 int, byte_69 int, byte_6a int, byte_6b int, byte_6c int, byte_6d int, byte_6e int, byte_6f int, byte_70 int, byte_71 int, byte_72 int, byte_73 int, byte_74 int, byte_75 int, byte_76 int, byte_77 int, byte_78 int, byte_79 int, byte_7a int, byte_7b int, byte_7c int, byte_7d int, byte_7e int, byte_7f int, byte_80 int, byte_81 int, byte_82 int, byte_83 int, byte_84 int, byte_85 int, byte_86 int, byte_87 int, byte_88 int, byte_89 int, byte_8a int, byte_8b int, byte_8c int, byte_8d int, byte_8e int, byte_8f int, byte_90 int, byte_91 int, byte_92 int, byte_93 int, byte_94 int, byte_95 int, byte_96 int, byte_97 int, byte_98 int, byte_99 int, byte_9a int, byte_9b int, byte_9c int, byte_9d int, byte_9e int, byte_9f int, byte_a0 int, byte_a1 int, byte_a2 int, byte_a3 int, byte_a4 int, byte_a5 int, byte_a6 int, byte_a7 int, byte_a8 int, byte_a9 int, byte_aa int, byte_ab int, byte_ac int, byte_ad int, byte_ae int, byte_af int, byte_b0 int, byte_b1 int, byte_b2 int, byte_b3 int, byte_b4 int, byte_b5 int, byte_b6 int, byte_b7 int, byte_b8 int, byte_b9 int, byte_ba int, byte_bb int, byte_bc int, byte_bd int, byte_be int, byte_bf int, byte_c0 int, byte_c1 int, byte_c2 int, byte_c3 int, byte_c4 int, byte_c5 int, byte_c6 int, byte_c7 int, byte_c8 int, byte_c9 int, byte_ca int, byte_cb int, byte_cc int, byte_cd int, byte_ce int, byte_cf int, byte_d0 int, byte_d1 int, byte_d2 int, byte_d3 int, byte_d4 int, byte_d5 int, byte_d6 int, byte_d7 int, byte_d8 int, byte_d9 int, byte_da int, byte_db int, byte_dc int, byte_dd int, byte_de int, byte_df int, byte_e0 int, byte_e1 int, byte_e2 int, byte_e3 int, byte_e4 int, byte_e5 int, byte_e6 int, byte_e7 int, byte_e8 int, byte_e9 int, byte_ea int, byte_eb int, byte_ec int, byte_ed int, byte_ee int, byte_ef int, byte_f0 int, byte_f1 int, byte_f2 int, byte_f3 int, byte_f4 int, byte_f5 int, byte_f6 int, byte_f7 int, byte_f8 int, byte_f9 int, byte_fa int, byte_fb int, byte_fc int, byte_fd int, byte_fe int, byte_ff int
);

CREATE TABLE magic (id serial PRIMARY KEY, description text UNIQUE);
CREATE TABLE peyd (id serial PRIMARY KEY, description text UNIQUE);
CREATE TABLE path (id serial PRIMARY KEY, content text);
CREATE TABLE export_name (id serial PRIMARY KEY, content text UNIQUE);

CREATE TABLE sample (
    id serial PRIMARY KEY,
    hash_sha256 VARCHAR(64) NOT NULL UNIQUE,
    hash_md5 VARCHAR(32) NOT NULL,
    hash_sha1 VARCHAR(40) NOT NULL,
    size int, -- in header
    code_histogram_id int REFERENCES byte_histogram(id),
    magic_id int REFERENCES magic(id),
    
    ssdeep text NOT NULL,
    imphash VARCHAR(32) NOT NULL,
    entropy double precision NOT NULL,
    
    file_size int, -- in byte on disk
    entry_point bigint,
    first_kb bytea,
    
    overlay_sha256 VARCHAR(64),
    overlay_size int, -- in byte
    overlay_ssdeep text NOT NULL,
    overlay_entropy double precision NOT NULL,

    build_timestamp timestamp,
    
    strings_count_of_length_at_least_10 int NOT NULL,
    strings_count int NOT NULL,
    
    export_name_id int REFERENCES export_name(id)
);

CREATE TABLE sample_function (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id) NOT NULL,
    "offset" bigint CHECK("offset" >= 0) NOT NULL,
    "size" int CHECK("size" >= 0) NOT NULL,
    "real_size" int CHECK("real_size" >= 0) NOT NULL,
    name text NOT NULL,
    calltype VARCHAR(20) NOT NULL,
    cc int NOT NULL,
    cost int NOT NULL,
    ebbs int NOT NULL,
    edges int NOT NULL,
    indegree int NOT NULL,
    nargs int NOT NULL,
    nbbs int NOT NULL,
    nlocals int NOT NULL,
    outdegree int NOT NULL,
    "type" VARCHAR(20) NOT NULL,
    opcodes_sha256 VARCHAR(64) NOT NULL,
    opcodes_crc32 VARCHAR(8) NOT NULL,
    cleaned_opcodes_sha256 VARCHAR(64) NOT NULL,
    cleaned_opcodes_crc32 VARCHAR(8) NOT NULL,
    opcodes json
);
CREATE INDEX sample_function_sample_id_idx ON sample_function(sample_id);
CREATE INDEX sample_function_cleaned_opcodes_crc32_idx ON sample_function(cleaned_opcodes_crc32);
CREATE INDEX sample_function_cleaned_opcodes_sha256_idx ON sample_function(cleaned_opcodes_sha256);

CREATE TABLE sample_has_source (
    sample_id int REFERENCES sample(id),
    source_id int REFERENCES sample_source(id),
    UNIQUE(sample_id, source_id)
);

CREATE TABLE sample_source (
    id serial PRIMARY KEY,
    identifier VARCHAR(50)
);

CREATE TABLE sample_has_peyd (
    sample_id int REFERENCES sample(id),
    peyd_id int REFERENCES peyd(id),
    UNIQUE(sample_id, peyd_id)
);
CREATE TABLE ioc (id serial PRIMARY KEY, content text UNIQUE);
CREATE TABLE sample_has_heuristic_ioc (sample_id int REFERENCES sample(id), ioc_id int REFERENCES ioc(id));
CREATE INDEX sample_has_heuristic_ioc_sample_id_idx ON sample_has_heuristic_ioc(sample_id);

CREATE TABLE debug_directory (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id) NOT NULL,
    timestamp timestamp,
    path_id int REFERENCES path(id),
    age bigint,
    signature text,
    guid VARCHAR(37)
);
CREATE INDEX debug_directory_sample_id_idx ON debug_directory(sample_id);

CREATE TABLE section_name (id serial PRIMARY KEY, content text UNIQUE);
CREATE TABLE section (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    hash_sha256 VARCHAR(64),
    name_id int REFERENCES section_name(id),
    
    virtual_address bigint CHECK(virtual_address >= 0),
    virtual_size bigint CHECK(virtual_size >= 0),
    raw_size bigint CHECK(raw_size >= 0),
    
    entropy double precision NOT NULL,
    ssdeep text NOT NULL,

    sort_order int CHECK(sort_order >= 0)
);
CREATE INDEX section_sample_id_idx ON section(sample_id);

CREATE TABLE resource_type_pair (id serial PRIMARY KEY, content_id text, content_str text);
CREATE TABLE resource_name_pair (id serial PRIMARY KEY, content_id text, content_str text);
CREATE TABLE resource_language_pair (id serial PRIMARY KEY, content_id text, content_str text);

CREATE TABLE resource (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    
    hash_sha256 VARCHAR(64) NOT NULL,
    "offset" bigint CHECK("offset" >= 0),
    "size" bigint CHECK("size" >= 0),
    actual_size int CHECK(actual_size >= 0),
    entropy double precision NOT NULL,
    ssdeep text NOT NULL,
    
    type_pair_id int REFERENCES resource_type_pair(id),
    name_pair_id int REFERENCES resource_name_pair(id),
    language_pair_id int REFERENCES resource_language_pair(id),

    sort_order int CHECK(sort_order >= 0)
);
CREATE INDEX resource_sample_id_idx ON resource(sample_id);

CREATE TABLE guid (id VARCHAR(32) PRIMARY KEY, sample_id int REFERENCES sample(id));
CREATE INDEX guid_sample_id_idx ON guid(sample_id);

CREATE TABLE export_symbol_name (id serial PRIMARY KEY, content text UNIQUE);
CREATE TABLE export_symbol (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    address bigint NOT NULL,
    ordinal text NOT NULL,
    name_id int REFERENCES export_symbol_name(id)
);
CREATE INDEX export_symbol_sample_id_idx ON export_symbol(sample_id);

CREATE TABLE dll_name (id serial PRIMARY KEY, content text UNIQUE);
CREATE TABLE import_name (id serial PRIMARY KEY, content text UNIQUE);
CREATE TABLE import (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    dll_name_id int REFERENCES dll_name(id) NOT NULL,
    address bigint NOT NULL,
    name_id int REFERENCES import_name(id)
);
CREATE INDEX import_sample_id_idx ON import(sample_id);

CREATE TYPE task_type AS ENUM('PEMetadata', 'R2Disassembly');

CREATE TABLE task_consumer (
    id serial PRIMARY KEY,
    name VARCHAR(25) NOT NULL
);
CREATE INDEX task_consumer_name_idx ON task_consumer(name);

CREATE TABLE task (
    id serial PRIMARY KEY,
    "type" task_type NOT NULL,
    payload json NOT NULL,
    created_at timestamp default current_timestamp,
    assigned_at timestamp,
    completed_at timestamp,
    consumer_id int REFERENCES task_consumer(id)
);
CREATE INDEX task_type_assigned_at_idx ON task("type", assigned_at);
