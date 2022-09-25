-- criação de banco de dados ecommerce conforme modelamento pessoal do desafio do bottcamp database
create database ecommerce2;
use ecommerce2;
-- criação de tabela de cliente
create table clients(
	idClients int auto_increment primary key,
    Pname varchar(45),
    Lname varchar(45),
    CPF char(11),
    endereço varchar(45),
    Address varchar(45),
    constraint unique_cpf unique(CPF)
);
alter table clients auto_increment=1;

-- criação de tabela de pedido
create table request(
	idRequest int auto_increment primary key,
    statusRequest boolean not null,
    descRequest varchar(30),
    frete float
);
alter table request auto_increment=1;

-- criação de tabela de produto
create table product(
	idProduct int auto_increment primary key,
    category enum('brinquedos', 'eletronicos', 'livros', 'domestico', 'utensilios', 'veiculo') not null,
    descProduct varchar(45),
    valueProduct float not null default 0
);
alter table product auto_increment=1;

-- criação da tabela de vendedores terceiro
create  table seller(
	idSeller int auto_increment primary key,
    socialName varchar(45),
    AbstName varchar(30),
    CNPJ char(15),
    CPF char(11),
    Address varchar(45),
    contact char(11),
    constraint	unique_cnpj unique(CNPJ),
    constraint	unique_cpf unique(CPF)
);
alter table seller auto_increment=1;

-- criação de tabela de fornecedor
create table provider(
	idProvider int auto_increment primary key,
    SocialName varchar(45) not null,
    AbstName varchar(30),
    CNPJ char(15) not null,
    contact char(11),
    constraint unique_cnpj_provider unique(CNPJ)
);
alter table provider auto_increment=1;

-- criação de tabela de estoque
create table productStorage(
	idPStorage int auto_increment primary key,
    pLocation varchar(45),
    quantity int default 0
);
alter table productStorage auto_increment=1;

-- criação de tabela de pessoa fisica cliente
create table physicalPerson(
	idPperson int auto_increment primary key,
    namefull varchar(60),
    CPF char(11) not null,
    address varchar(45) not null,
    constraint unique_cpf_Pperson unique(CPF)
);
alter table physicalperson auto_increment=1;

-- criação de tabela de pessoa juridica
create table legalPerson(
	idLperson int auto_increment primary key,
    SocialName varchar(60) not null,
    AbstName varchar(30),
    CNPJ char(15) not null,
    address varchar(45) not null,
    contact char(11),
    constraint unique_cnpj_lperson unique(CNPJ)
);
alter table legalPerson auto_increment=1;

-- criação de tabela de financeiro
create table financial(
    idFpedido int,
    situation enum('Aprovado', 'Reprovado', 'Em analise') default 'Em analise',
    payment enum('cartão de credito', 'cartão de debito', 'boleto', 'pix', 'transferencia bancaria') not null default 'cartão de credito',
    purchaseshistoric varchar(60),
    primary key(idFpedido),
    constraint fk_financial_pedido foreign key (idFpedido) references request(idRequest)
);

-- criação de tabela de entrega
create table delivery(
	idDResquest int,
    idDfinancial int,
    statusdelivery enum('entregue', 'A caminho', 'aguardando liberação') default 'aguardando liberação',
    trackingCode varchar(30) not null,
    locationDelivery varchar(60) not null,
    locationReference varchar(60),
    primary key (idDResquest, idDfinancial),
    constraint fk_delivery_request foreign key (idDResquest) references request(idRequest),
    constraint fk_delivery_financial foreign key (idDfinancial) references financial(idFpedido)
);

-- criação de tabela de produto/pedido
create table prodResquest(
	idPRResquest int,
    idPRProduct int,
    quantity int not null,
    primary key (idPRResquest, idPRProduct),
    constraint fk_prodrequest_request foreign key (idPRResquest) references request(idRequest),
    constraint fk_prodrequest_product foreign key (idPRProduct) references product(idProduct)
);

-- criação de tabela de produto/estoque
create table prodStorage(
	idPSProduct int,
    idPSStorage int,
    quantity int  not null,
    primary key (idPSProduct, idPSStorage),
    constraint fk_prodstorage_product foreign key (idPSProduct) references product(idProduct),
    constraint fk_prodstorage_storage foreign key (idPSStorage) references productStorage(idPStorage)
);

-- criação de tabela produto/fornecedor
create table prodProvider(
	idPPProduct int,
    idPPProvider int,
    primary key (idPPProduct, idPPProvider),
    constraint fk_prodprovider_product foreign key (idPPProduct) references product(idProduct),
    constraint fk_prodprovider_provider foreign key (idPPProvider) references provider(idProvider)
);

-- criação de tabela produto/vendedor
create table prodSeller(
	idPSelProduct int,
    idPSelSeller int,
    quantity int not null,
    primary key (idPSelProduct, idPSelSeller),
    constraint fk_prodseller_product foreign key (idPSelProduct) references product(idProduct),
    constraint fk_prodseller_seller foreign key (idPSelSeller) references seller(idSeller)
);

-- criação de tabela conta
create table accounts(
	icAclients int,
    idAPPerson int,
    idALPerson int,
    typeAccounts enum('fisica','juridica') not null,
    primary key (icAclients, idAPPerson, idALPerson),
    constraint fk_accounts_clients foreign key (icAclients) references clients(idClients),
    constraint fk_accounts_phisycalperson foreign key (idAPPerson) references physicalPerson(idPperson),
    constraint fk_accounts_legalperson foreign key (idALPerson) references legalPerson(idLperson)
);

-- criação de tabela de dados de cobrança
create table billingData(
	idBDfinancial int,
    idBDAccounts int,
    idBDPPerson int,
    idBDLperson int,
    primary key(idBDfinancial, idBDAccounts, idBDPPerson, idBDLperson),
    constraint fk_billingdata_financial foreign key (idBDfinancial) references financial(idFpedido),
    constraint fk_billingdata_accounts foreign key (idBDAccounts) references accounts(icAclients),
    constraint fk_billingdata_pperson foreign key (idBDPPerson) references accounts(idAPPerson),
    constraint fk_billingdata_lperson foreign key (idBDLperson) references accounts(idALPerson)
);

show tables;

select * from accounts;
select * from financial where (situation = 'Em analise'); 
select * from clients order by Pname;


