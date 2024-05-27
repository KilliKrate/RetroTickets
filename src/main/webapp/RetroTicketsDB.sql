create table APP.UTENTI
(
    USERNAME     VARCHAR(63)  not null
        constraint UTENTI_PK
            primary key,
    PASSWORD     VARCHAR(63)  not null,
    NOME         VARCHAR(255) not null,
    COGNOME      VARCHAR(255) not null,
    DATA_NASCITA DATE         not null,
    EMAIL        VARCHAR(255) not null
        unique,
    NUM_TELEFONO CHAR(10)     not null
);



create table localita
(
    nome VARCHAR(255)
        constraint localita_pk
            primary key
);

insert into APP.LOCALITA (NOME)
values  ('Arco'),
        ('Povo'),
        ('Riva del Garda'),
        ('Rovereto'),
        ('Trento');

create table APP.CATEGORIE
(
    NOME VARCHAR(255) not null
        constraint CATEGORIE_PK
            primary key
);

create table eventi
(
    id        INTEGER generated always as identity
        constraint eventi_pk
            primary key,
    nome      VARCHAR(255) not null,
    localita  VARCHAR(255) not null
        constraint eventi_LOCALITA_NOME_fk
            references LOCALITA,
    categoria VARCHAR(255) not null
        constraint eventi_CATEGORIE_NOME_fk
            references CATEGORIE,
    clicks    integer default 0 not null,
    data timestamp default current_timestamp not null
);

create table sconti
(
    id       INTEGER generated always as identity
        constraint sconti_pk
            primary key,
    evento   INTEGER       not null
        constraint sconti_EVENTI_ID_fk
            references EVENTI,
    percentuale   DECIMAL(3, 2) not null,
    scadenza timestamp default current_timestamp not null
);
