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
    NUM_TELEFONO CHAR(10)     not null,
    admin boolean default false not null

);

create table sessioni
(
    sessione      varchar(255) not null
        constraint sessioni_pk
            primary key,
    data_scadenza bigint         not null,
    username        varchar(63)  not null
        constraint "sessioni_UTENTI_USERNAME_fk"
            references UTENTI (username)
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

/*
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
*/

create table posti
(
    NOME     VARCHAR(255)  not null,
    PREZZO   DECIMAL(8, 2) not null,
    EVENTO   INTEGER       not null
        constraint "posti_EVENTI_ID_fk"
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

INSERT INTO UTENTI (USERNAME, PASSWORD, NOME, COGNOME, DATA_NASCITA, EMAIL, NUM_TELEFONO, ADMIN) VALUES ('utente', 'utente!08', 'matteo', 'casarotto', '2024-06-06', 'casarottosantana@gmail.com', '3348548267', false);
INSERT INTO UTENTI (USERNAME, PASSWORD, NOME, COGNOME, DATA_NASCITA, EMAIL, NUM_TELEFONO, ADMIN) VALUES ('admin', '08nimda!', 'ovidiu costin', 'andrioaia', '2024-06-12', 'ovidiu.andrioaia@yahoo.it', '3922931424', true);
INSERT INTO UTENTI (USERNAME, PASSWORD, NOME, COGNOME, DATA_NASCITA, EMAIL, NUM_TELEFONO, ADMIN) VALUES ('example1', '08nimda!', 'example', 'example', '2024-06-12', 'example1@mail.it', '1234567890', false);
INSERT INTO UTENTI (USERNAME, PASSWORD, NOME, COGNOME, DATA_NASCITA, EMAIL, NUM_TELEFONO, ADMIN) VALUES ('example2', '08nimda!', 'example', 'example', '2024-06-12', 'example2@mail.it', '1234567890', false);
INSERT INTO UTENTI (USERNAME, PASSWORD, NOME, COGNOME, DATA_NASCITA, EMAIL, NUM_TELEFONO, ADMIN) VALUES ('example3', '08nimda!', 'example', 'example', '2024-06-12', 'example3@mail.it', '1234567890', false);


create table ACQUISTI
(
    id     INTEGER generated always as identity
        constraint ACQUISTI_pk
            primary key,
    evento INTEGER                             not null,
    posto  VARCHAR(255)                        not null,
    utente VARCHAR(63)                         not null
        constraint ACQUISTI_UTENTI_USERNAME_FK
            references ADMIN.UTENTI,
    data   TIMESTAMP default CURRENT_TIMESTAMP not null,
    prezzo DECIMAL(8, 2)                       not null,
    constraint ACQUISTI_POSTI_NOME_EVENTO_fk
        foreign key (evento, posto) references POSTI (EVENTO, NOME)
);

create view ACQUISTI_UTENTE as
SELECT U.USERNAME, COUNT(A.UTENTE) AS num_acquisti FROM UTENTI as U LEFT JOIN ACQUISTI AS A ON U.USERNAME = A.UTENTE GROUP BY U.USERNAME ;

