SET SCHEMA ADMIN;

create table utenti
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

insert into localita (NOME)
values  ('Arco'),
        ('Povo'),
        ('Riva del Garda'),
        ('Rovereto'),
        ('Trento');

create table categorie
(
    NOME VARCHAR(255) not null
        constraint CATEGORIE_PK
            primary key
);

insert into CATEGORIE (NOME)
values  ('Concerto'),
        ('Evento sportivo'),
        ('Spettacolo teatrale'),
        ('Visita guidata');

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
    data timestamp default current_timestamp not null,
    image VARCHAR(255) not null
);

INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('Kiss', 'Povo', 'Concerto', default, '2024-05-29 10:44:05.000000000', 'yvette-de-wit-NYrVisodQ2M-unsplash.jpg');
INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('Red Hot Chili Peppers', 'Rovereto', 'Concerto', default, '2024-05-30 14:44:29.000000000', 'photo-1540039155733-5bb30b53aa14.jpg');
INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('Spice Girls', 'Trento', 'Concerto', default, '2024-06-03 19:44:48.000000000', 'photo-1459749411175-04bf5292ceea.jpg');
INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('1992 Summer Olympics', 'Arco', 'Evento sportivo', default, '2024-06-06 09:45:13.000000000', 'gentrit-sylejmani-JjUyjE-oEbM-unsplash.jpg');
INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('Museo delle forcine per i capelli', 'Riva del Garda', 'Visita guidata', default, '2024-06-09 16:00:00.000000000', 'chad-greiter--0gBnnMdQPw-unsplash.jpg');
INSERT INTO EVENTI (NOME, LOCALITA, CATEGORIA, CLICKS, DATA, IMAGE) VALUES ('Museo del freddo ai piedi', 'Riva del Garda', 'Visita guidata', 0, '2024-06-10 13:05:15.000000000', 'ian-dooley-ZLBzMGle-nE-unsplash.jpg');

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

create table posti
(
    NOME     VARCHAR(255)  not null,
    PREZZO   DECIMAL(8, 2) not null,
    EVENTO   INTEGER       not null
        constraint "posti_EVENTI_null_fk"
            references EVENTI,
    constraint POSTI_PK
        primary key (EVENTO, NOME)
);

INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Zona principale', 85.00, 1);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Sotto al palco', 120.00, 1);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Zona principale', 85.00, 2);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Sotto al palco', 120.00, 2);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Zona principale', 85.00, 3);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Sotto al palco', 120.00, 3);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Platea', 200.00, 4);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Ingresso', 15.00, 5);
INSERT INTO POSTI (NOME, PREZZO, EVENTO) VALUES ('Ingresso', 15.00, 6);
