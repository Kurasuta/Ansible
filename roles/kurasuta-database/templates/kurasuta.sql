SET search_path TO public;
DROP TABLE IF EXISTS magic, sample, section, section_name, resource_name, resource_type, resource, resource_sublang, export_symbol_name, guid, export_symbol CASCADE;

CREATE TABLE magic (
    id serial PRIMARY KEY,
    short VARCHAR(10) UNIQUE,
    description text
);
-- ALTER TABLE magic OWNER to worker;

CREATE TABLE sample (
    id serial PRIMARY KEY,
    hash_sha256 VARCHAR(64) NOT NULL,
    hash_md5 VARCHAR(32) NOT NULL,
    hash_sha1 VARCHAR(40) NOT NULL,

    magic_id int REFERENCES magic(id),
    file_size int, -- in byte on disk
    entry_point int,
    overlay_size int, -- in byte
    overlay_sha256 VARCHAR(64),

    build_timestamp timestamp,
    debug_timestamp timestamp,
    pdb_timestamp timestamp,
    pdb_path text,
    pdb_age int CHECK(pdb_age >= 0),
    export_name text,
    export_table_timestamp timestamp,
    resource_timestamp timestamp,
    certificate_signing_timestamp timestamp
);

CREATE TABLE section_name (
    id serial PRIMARY KEY,
    name text UNIQUE
);

CREATE TABLE section (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    hash_sha256 VARCHAR(64),
    name_id int REFERENCES section_name(id),
    virtual_address int CHECK(virtual_address >= 0),
    virtual_size int CHECK(virtual_size >= 0),
    raw_size int CHECK(raw_size >= 0),

    sort_order int CHECK(sort_order >= 0)
);

CREATE TABLE resource_name (
    id serial PRIMARY KEY,
    name text UNIQUE
);

CREATE TABLE resource_type (
    id serial PRIMARY KEY,
    name text UNIQUE
);

CREATE TABLE resource_sublang (
    id serial PRIMARY KEY,
    name text UNIQUE
);

CREATE TABLE resource (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    hash_sha256 VARCHAR(64),
    name_id int REFERENCES resource_name(id),
    lang_id text,
    lang_name text,
    type_id int REFERENCES resource_type(id),
    sublang_id int REFERENCES resource_sublang(id),
    size int CHECK(size >= 0),

    sort_order int CHECK(sort_order >= 0)
);

CREATE TABLE guid (
    id VARCHAR(32) PRIMARY KEY,
    sample_id int REFERENCES sample(id)
);

CREATE TABLE export_symbol_name (
    id serial PRIMARY KEY,
    name text UNIQUE
);

CREATE TABLE export_symbol (
    id serial PRIMARY KEY,
    sample_id int REFERENCES sample(id),
    name_id int REFERENCES export_symbol_name(id),

    sort_order int CHECK(sort_order >= 0)
);
