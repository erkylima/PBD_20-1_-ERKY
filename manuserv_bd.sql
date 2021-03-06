PGDMP     -                    y            manuserv    12.2    12.2 3    P           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            Q           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            R           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            S           1262    50591    manuserv    DATABASE     ?   CREATE DATABASE manuserv WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE manuserv;
                postgres    false            ?            1255    124726    process_carro_audit()    FUNCTION        CREATE FUNCTION public.process_carro_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create a row in emp_audit to reflect the operation performed on emp,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('delete', 'ms_carro', CURRENT_USER, NOW(),CONCAT (OLD.marca, ' | ', OLD.modelo, ' | ', OLD.ano, ' | ', OLD.placa), null); 
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('update', 'ms_carro', CURRENT_USER, NOW(),CONCAT (OLD.marca, ' | ', OLD.modelo, ' | ', OLD.ano, ' | ', OLD.placa), CONCAT (NEW.marca, ' | ', NEW.modelo, ' | ', NEW.ano, ' | ', new.placa)); 
            
			RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('insert', 'ms_carro', CURRENT_USER, NOW(),null, CONCAT (NEW.marca, ' | ', NEW.modelo, ' | ', NEW.ano, ' | ', new.placa)); 
			
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;
 ,   DROP FUNCTION public.process_carro_audit();
       public          postgres    false            ?            1255    124733    process_servico_audit()    FUNCTION     ?  CREATE FUNCTION public.process_servico_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create a row in emp_audit to reflect the operation performed on emp,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('delete', 'ms_servico', CURRENT_USER, NOW(),CONCAT (OLD.preco, ' | ', OLD.carro_id, ' | ', OLD.tipo_servico_id), null); 
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('update', 'ms_servico', CURRENT_USER, NOW(),CONCAT (OLD.preco, ' | ', OLD.carro_id, ' | ', OLD.tipo_servico_id), CONCAT (NEW.preco, ' | ', NEW.carro_id, ' | ', NEW.tipo_servico_id)); 
            
			RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('insert', 'ms_servico', CURRENT_USER, NOW(),null, CONCAT (NEW.preco, ' | ', NEW.carro_id, ' | ', NEW.tipo_servico_id)); 
			
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;
 .   DROP FUNCTION public.process_servico_audit();
       public          postgres    false            ?            1255    124730    process_usuario_audit()    FUNCTION       CREATE FUNCTION public.process_usuario_audit() RETURNS trigger
    LANGUAGE plpgsql
    AS $$    BEGIN
        --
        -- Create a row in emp_audit to reflect the operation performed on emp,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('delete', 'ms_usuario', CURRENT_USER, NOW(),CONCAT (OLD.nome, ' | ', OLD.usuario, ' | ', OLD.email, ' | ', OLD.senha), null); 
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('update', 'ms_usuario', CURRENT_USER, NOW(),CONCAT (OLD.nome, ' | ', OLD.usuario, ' | ', OLD.email, ' | ', OLD.senha), CONCAT (NEW.nome, ' | ', NEW.usuario, ' | ', NEW.email, ' | ', NEW.senha)); 
            
			RETURN NEW;
        ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO ms_auditoria(acao,tabela, usuario, data_acao, antes, depois) values ('insert', 'ms_usuario', CURRENT_USER, NOW(),null, CONCAT (NEW.nome, ' | ', NEW.usuario, ' | ', NEW.email, ' | ', NEW.senha)); 
			
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;
 .   DROP FUNCTION public.process_usuario_audit();
       public          postgres    false            ?            1259    124701    ms_auditoria    TABLE       CREATE TABLE public.ms_auditoria (
    id bigint NOT NULL,
    acao character varying(255),
    tabela character varying(255),
    usuario character varying(255),
    data_acao timestamp without time zone,
    antes character varying(255),
    depois character varying(255)
);
     DROP TABLE public.ms_auditoria;
       public         heap    postgres    false            ?            1259    124699    ms_auditoria_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_auditoria ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_auditoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    215            ?            1259    91613    ms_carro    TABLE     ?   CREATE TABLE public.ms_carro (
    id bigint NOT NULL,
    ano integer,
    marca character varying(255),
    modelo character varying(255),
    placa character varying(255),
    empresa_id bigint,
    empresa bigint
);
    DROP TABLE public.ms_carro;
       public         heap    postgres    false            ?            1259    91611    ms_carro_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_carro ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_carro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    205            ?            1259    50618 
   ms_empresa    TABLE     }   CREATE TABLE public.ms_empresa (
    id bigint NOT NULL,
    cnpj character varying(255),
    nome character varying(255)
);
    DROP TABLE public.ms_empresa;
       public         heap    postgres    false            ?            1259    50616    ms_empresa_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_empresa ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_empresa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    203            ?            1259    91637    ms_procedimento    TABLE     ?   CREATE TABLE public.ms_procedimento (
    id bigint NOT NULL,
    nome character varying(255),
    ordem integer,
    tiposervico_id bigint
);
 #   DROP TABLE public.ms_procedimento;
       public         heap    postgres    false            ?            1259    91635    ms_procedimento_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_procedimento ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_procedimento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    207            ?            1259    91644 
   ms_servico    TABLE     ?   CREATE TABLE public.ms_servico (
    id bigint NOT NULL,
    preco double precision NOT NULL,
    carro_id bigint,
    tipo_servico_id bigint
);
    DROP TABLE public.ms_servico;
       public         heap    postgres    false            ?            1259    91642    ms_servico_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_servico ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_servico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    209            ?            1259    91651    ms_tipo_servico    TABLE     ?   CREATE TABLE public.ms_tipo_servico (
    id bigint NOT NULL,
    descricao character varying(255),
    nome character varying(255)
);
 #   DROP TABLE public.ms_tipo_servico;
       public         heap    postgres    false            ?            1259    91649    ms_tipo_servico_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_tipo_servico ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_tipo_servico_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    211            ?            1259    91712 
   ms_usuario    TABLE       CREATE TABLE public.ms_usuario (
    id bigint NOT NULL,
    authorities character varying(255),
    email character varying(255),
    nome character varying(255),
    senha character varying(255),
    usuario character varying(255),
    empresa_id bigint
);
    DROP TABLE public.ms_usuario;
       public         heap    postgres    false            ?            1259    91710    ms_usuario_id_seq    SEQUENCE     ?   ALTER TABLE public.ms_usuario ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.ms_usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    213            M          0    124701    ms_auditoria 
   TABLE DATA           [   COPY public.ms_auditoria (id, acao, tabela, usuario, data_acao, antes, depois) FROM stdin;
    public          postgres    false    215   2K       C          0    91613    ms_carro 
   TABLE DATA           V   COPY public.ms_carro (id, ano, marca, modelo, placa, empresa_id, empresa) FROM stdin;
    public          postgres    false    205   9L       A          0    50618 
   ms_empresa 
   TABLE DATA           4   COPY public.ms_empresa (id, cnpj, nome) FROM stdin;
    public          postgres    false    203   ?L       E          0    91637    ms_procedimento 
   TABLE DATA           J   COPY public.ms_procedimento (id, nome, ordem, tiposervico_id) FROM stdin;
    public          postgres    false    207   ?M       G          0    91644 
   ms_servico 
   TABLE DATA           J   COPY public.ms_servico (id, preco, carro_id, tipo_servico_id) FROM stdin;
    public          postgres    false    209   jN       I          0    91651    ms_tipo_servico 
   TABLE DATA           >   COPY public.ms_tipo_servico (id, descricao, nome) FROM stdin;
    public          postgres    false    211   ?N       K          0    91712 
   ms_usuario 
   TABLE DATA           ^   COPY public.ms_usuario (id, authorities, email, nome, senha, usuario, empresa_id) FROM stdin;
    public          postgres    false    213   0O       T           0    0    ms_auditoria_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.ms_auditoria_id_seq', 11, true);
          public          postgres    false    214            U           0    0    ms_carro_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.ms_carro_id_seq', 8, true);
          public          postgres    false    204            V           0    0    ms_empresa_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.ms_empresa_id_seq', 28, true);
          public          postgres    false    202            W           0    0    ms_procedimento_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ms_procedimento_id_seq', 3, true);
          public          postgres    false    206            X           0    0    ms_servico_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.ms_servico_id_seq', 6, true);
          public          postgres    false    208            Y           0    0    ms_tipo_servico_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ms_tipo_servico_id_seq', 1, true);
          public          postgres    false    210            Z           0    0    ms_usuario_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.ms_usuario_id_seq', 23, true);
          public          postgres    false    212            ?
           2606    124708    ms_auditoria ms_auditoria_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.ms_auditoria
    ADD CONSTRAINT ms_auditoria_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.ms_auditoria DROP CONSTRAINT ms_auditoria_pkey;
       public            postgres    false    215            ?
           2606    91620    ms_carro ms_carro_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.ms_carro
    ADD CONSTRAINT ms_carro_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.ms_carro DROP CONSTRAINT ms_carro_pkey;
       public            postgres    false    205            ?
           2606    50625    ms_empresa ms_empresa_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.ms_empresa
    ADD CONSTRAINT ms_empresa_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.ms_empresa DROP CONSTRAINT ms_empresa_pkey;
       public            postgres    false    203            ?
           2606    91641 $   ms_procedimento ms_procedimento_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ms_procedimento
    ADD CONSTRAINT ms_procedimento_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ms_procedimento DROP CONSTRAINT ms_procedimento_pkey;
       public            postgres    false    207            ?
           2606    91648    ms_servico ms_servico_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.ms_servico
    ADD CONSTRAINT ms_servico_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.ms_servico DROP CONSTRAINT ms_servico_pkey;
       public            postgres    false    209            ?
           2606    91658 $   ms_tipo_servico ms_tipo_servico_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.ms_tipo_servico
    ADD CONSTRAINT ms_tipo_servico_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.ms_tipo_servico DROP CONSTRAINT ms_tipo_servico_pkey;
       public            postgres    false    211            ?
           2606    91719    ms_usuario ms_usuario_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.ms_usuario
    ADD CONSTRAINT ms_usuario_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.ms_usuario DROP CONSTRAINT ms_usuario_pkey;
       public            postgres    false    213            ?
           2620    124727    ms_carro manuserv_audit_ins    TRIGGER     ?   CREATE TRIGGER manuserv_audit_ins AFTER INSERT OR DELETE OR UPDATE ON public.ms_carro FOR EACH ROW EXECUTE FUNCTION public.process_carro_audit();
 4   DROP TRIGGER manuserv_audit_ins ON public.ms_carro;
       public          postgres    false    228    205            ?
           2620    124734    ms_servico manuserv_audit_ins    TRIGGER     ?   CREATE TRIGGER manuserv_audit_ins AFTER INSERT OR DELETE OR UPDATE ON public.ms_servico FOR EACH ROW EXECUTE FUNCTION public.process_servico_audit();
 6   DROP TRIGGER manuserv_audit_ins ON public.ms_servico;
       public          postgres    false    230    209            ?
           2620    124731    ms_usuario manuserv_audit_ins    TRIGGER     ?   CREATE TRIGGER manuserv_audit_ins AFTER INSERT OR DELETE OR UPDATE ON public.ms_usuario FOR EACH ROW EXECUTE FUNCTION public.process_usuario_audit();
 6   DROP TRIGGER manuserv_audit_ins ON public.ms_usuario;
       public          postgres    false    213    229            ?
           2606    91735 &   ms_usuario fk77wwhd7anhit16dl537q7oecg    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_usuario
    ADD CONSTRAINT fk77wwhd7anhit16dl537q7oecg FOREIGN KEY (empresa_id) REFERENCES public.ms_empresa(id);
 P   ALTER TABLE ONLY public.ms_usuario DROP CONSTRAINT fk77wwhd7anhit16dl537q7oecg;
       public          postgres    false    203    2732    213            ?
           2606    91699 &   ms_servico fk9mshl6iwqybjix53dpqd5w7bm    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_servico
    ADD CONSTRAINT fk9mshl6iwqybjix53dpqd5w7bm FOREIGN KEY (tipo_servico_id) REFERENCES public.ms_tipo_servico(id);
 P   ALTER TABLE ONLY public.ms_servico DROP CONSTRAINT fk9mshl6iwqybjix53dpqd5w7bm;
       public          postgres    false    209    2740    211            ?
           2606    91694 &   ms_servico fkbagxirkel2kassr9l2cndv90y    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_servico
    ADD CONSTRAINT fkbagxirkel2kassr9l2cndv90y FOREIGN KEY (carro_id) REFERENCES public.ms_carro(id);
 P   ALTER TABLE ONLY public.ms_servico DROP CONSTRAINT fkbagxirkel2kassr9l2cndv90y;
       public          postgres    false    209    205    2734            ?
           2606    91764 +   ms_procedimento fkdo0g5m29chrcmueb2iqq7pluk    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_procedimento
    ADD CONSTRAINT fkdo0g5m29chrcmueb2iqq7pluk FOREIGN KEY (tiposervico_id) REFERENCES public.ms_tipo_servico(id);
 U   ALTER TABLE ONLY public.ms_procedimento DROP CONSTRAINT fkdo0g5m29chrcmueb2iqq7pluk;
       public          postgres    false    2740    211    207            ?
           2606    124549 $   ms_carro fkfjyu5i9n97dp8v2a5sci7icyg    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_carro
    ADD CONSTRAINT fkfjyu5i9n97dp8v2a5sci7icyg FOREIGN KEY (empresa) REFERENCES public.ms_empresa(id);
 N   ALTER TABLE ONLY public.ms_carro DROP CONSTRAINT fkfjyu5i9n97dp8v2a5sci7icyg;
       public          postgres    false    203    2732    205            ?
           2606    91674 $   ms_carro fkrxt3xitlg4p6a1uu5qh7j2vs8    FK CONSTRAINT     ?   ALTER TABLE ONLY public.ms_carro
    ADD CONSTRAINT fkrxt3xitlg4p6a1uu5qh7j2vs8 FOREIGN KEY (empresa_id) REFERENCES public.ms_empresa(id);
 N   ALTER TABLE ONLY public.ms_carro DROP CONSTRAINT fkrxt3xitlg4p6a1uu5qh7j2vs8;
       public          postgres    false    205    2732    203            M   ?   x????J?0?s?}Cf21IoRVV?H?? ed?n??
??dڋT???????i??$^??C;I??8?q????J␲\ ??w7M?Y4?c?Ż?k??	???j?4^z6??t?Z??6??م?[? P:?v??)???DPF{???&}?)?UR?_`M?+?H/???5u?1???8?Yfc????ߏ?_?3?]F?ZH??r?Q???q\>O,???XP???K?????WR?/@???      C   ?   x?u??
?0???+?ɽ?m???	R]uS??B???????f???5?}p?z"f???a/㳅?_???%??L?$?.?"?vg?n??O]?3T??,?r?pXר???o\??9^???E??Q?[B2?0?;??d3i?J?,+6?      A   ?   x?E?Aj1E??)|?`il??lh	??????(?????酺(9?\???t????/??4b?O?????{?2.w??sz?5!Y??Y??????&h??T?:?-?i????3͜?}????=??^2Ĝ??d?8?????&5u??????l?S?l<?K??????9??Ƣ?e??g?NbC???#?? ?}0??O??"????iC?      E   ?   x?m?;?@Dk?)|??#A? ??k?J?8rH?u5???p??tϞ??
?dfE?HP?w5?H??Yp?y2B{?@i?????VeP??#[?ZZ!L?s?Μ?C??t??(P|???{??*+=?y[????xW????Am?m???S?>k      G   6   x?=ʹ  ??.???f????F+T6???0????g\?_۱?E?\?      I   p   x?3?J???????|??T??\???Tΐ???D? /??ˈ?1????T??|??????\?lf^V*DkjNjI??-y? m?
ɉEE??.???y?7?d&???)?????? p?/v      K   ?  x???͒?8??p??5? ???QD??j??4DQ~???:f1?]G????م???9I?'?=9??YY???ձi?????6??????8?"J???<???ώS?=J??y??'Z??MO??r?>???Т?Rߏ6?"??	PixIG??:X nPK3F?\ejTը??w?1_;'???????o??ǖ?-M?U?K??yܸ?_j???%Y䇫DSB??w.i?5???Vh???)?Ф?@S?x__!UQ??????'o1??鰚sJX???7?|?n???k?????8??p_.&???U]澐??&?Vܧ?"= Q|2?????d,?oq7I?????Q?5r????OZS??=pG??????;?}v??E????+?????a?B?l?I?|%?6ͧWiH???????V?<ⶻo9-???\¸?x???|?G???a????63;6???V#N7j?[???? ?H??7??Co?I_6w?,?????X E??t??Yw??,.6?д?_%????Gמ6s^?D??f?VP?U E?!???Cp??<??l?R_???7??[N?Lwn?#??<?<?W??+yẍ?ƒ= ??X^\~?2P`A???=?^?????)?O?v???/O1???|?2?Q^g?,j+).=?W?+?????2 ??i|:yڦ??M????????c?m???m?g3????|????ˮ?j?????<?#,De?a??DQP????<??|???p+*???????????ߝ??"???h?t??vb?Llr赁b?Ŵm?i?k??C?%???t???$????33????S?????s??(T?a$Xt!?_5p?ވ߾?N}??5???aop?B??GGە.??4??m2?*??.9GK?6
?>?UX/~????r?|?z???ٿ8?e????     