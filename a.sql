--Student: Alex Marshall
--Lab1A
--1. Create tables and constraints

create table Account (
  Account_Number number(7,0)
    constraint PK_Account_AccNumber primary key
    constraint NN_Account_AccNumber not null,
  Account_Balance number(13,2)
    constraint NN_Account_AccBalance not null
    constraint CK_Account_AccBalance check (Account_Balance >= 0)
);
create table Broker (
  Broker_Number number(7,0)
    constraint PK_Broker_BrkNumber primary key
    constraint NN_Broker_BrkNumber not null,
  First_Name varchar2(25)
    constraint NN_Broker_FName not null,
  Last_Name varchar2(30)
    constraint NN_Broker_LName not null,
  Area_Code number(3,0)
    default 780
    constraint NL_Broker_AreaCode null
    constraint CK_Broker_AreaCode check (Area_Code between 100 and 999),
  Phone_Number number(7,0)
    constraint NL_Broker_PNumber null,
  Email_Address varchar2(50)
    constraint NL_Broker_Email not null
    constraint CK_Broker_Email check (Email_Address like '%@%')
);
create table Exchange (
  Exchange_Code varchar2(4)
    constraint PK_Exchange_ExCode primary key
    constraint NN_Exchange_ExCode not null,
  Description varchar2(50)
    constraint NN_Exchange_Desc not null,
  Country varchar2(20)
    constraint NL_Exchange_Country null
);
create table Stock (
  Stock_Code varchar2(10)
    constraint PK_Stock_StCode primary key
    constraint NN_Stock_StCode not null,
  Stock_Name varchar2(50)
    constraint NN_Stock_StName not null
);
create table Exchange_Stock (
  Exchange_Code varchar2(4)
    constraint NN_ExStock_ExCode not null
    constraint FK_ExStockExCode_ExchExCode references Exchange (Exchange_Code),
  Stock_Code varchar2(10)
    constraint NN_ExStock_StCode not null
    constraint FK_ExStockStCode_StockStCode references Stock (Stock_Code),
  Active_YN char(1)
    constraint NN_ExStock_Active not null
    constraint CK_ExStock_Active check (Active_YN in ('Y','N')),
  constraint PK_ExStock_ExCodeStCode primary key (Exchange_Code, Stock_Code)
);

create table Investor (
  Investor_Number number(7,0)
    constraint PK_Investor_InvNumber primary key
    constraint NN_Investor_InvNumber not null,
  First_Name varchar2(25)
    constraint NN_Investor_FName not null,
  Last_Name varchar2(30)
    constraint NN_Investor_LName not null,
  Street_Address varchar2(35)
    constraint NL_Investor_Address null,
  City varchar2(25)
    constraint NL_Investor_City null,
  Province char(2)
    constraint NL_Investor_Province null
    constraint CK_Investor_Province check (regexp_like (Province,'[A-Z][A-Z]')),
  Postal_Code varchar2(7)
    constraint NL_Investor_PostalCode null
    constraint CK_Investor_PostalCode check
      (regexp_like (Postal_Code,'[A-Z][0-9][A-Z] [0-9][A-Z][0-9]') or
      (regexp_like (Postal_Code,'[1-9][0-9][0-9][0-9][0-9]')
        and length(Postal_Code) = 5)),
  Area_Code number(3,0)
    default 780
    constraint NN_Investor_AreaCode not null
    constraint CK_Investor_AreaCode check (Area_Code between 100 and 999),
  Phone_Number number(7,0)
    constraint NN_Investor_PhoneNumber not null,
  Email_Address varchar2(50)
    constraint NN_Investor_Email not null
    constraint CK_Investor_Email check (Email_Address like '%@%'),
  Account_Number number(7,0)
    constraint NN_Investor_AccNumber not null
    constraint FK_InvestorAccNo_AccountAccNo references Account (Account_Number)
);
create table Portfolio (
  Portfolio_Number number(7,0)
    constraint PK_Portfolio_PNumber primary key
    constraint NN_Portfolio_PNumber not null,
  Investor_Number number(7,0)
    constraint NN_Portfolio_InvNumber not null
    constraint FK_PortInvNo_InvestorInvNo references Investor (Investor_Number),
  Portfolio_Description varchar2(50)
    constraint NL_Portfolio_PortDescription null
);
create table Transaction (
  Portfolio_Number Number(7,0)
    constraint NN_Transaction_PortNumber not null
    constraint FK_TransPortNo_PortPortNo references
      Portfolio (Portfolio_Number),
  Stock_Code varchar2(10)
    constraint NN_Transaction_StCode not null
    constraint FK_TransStCode_StockStCode references Stock (Stock_Code),
  Transaction_Date Date
    default sysdate
    constraint NN_Transaction_TranDate not null,
  Exchange_Code varchar2(4)
    constraint NN_Transaction_ExCode not null
    constraint FK_TransExCode_ExExCode references Exchange (Exchange_Code),
  Broker_Number number(7,0)
    constraint NN_Transaction_BrkNumber not null
    constraint FK_TransBrkNo_BrkBrkNo references Broker (Broker_Number),
  Buy_Sell char(1)
    constraint NN_Transaction_BuySell not null
    constraint CK_Transaction_BuySell check (Buy_Sell in ('B','S')),
  Quantity number(7,0)
    constraint NN_Transaction_Quantity not null
    constraint CK_Transaction_Quantity check (Quantity > 0),
  Price_Per_Share number(6,2)
    constraint NN_Transaction_PricePerShare not null
    constraint CK_Transaction_PricePerShare check (Price_Per_Share >= 0),
  constraint PK_Transaction_PNumSCodeTDate primary key
    (Portfolio_Number, Stock_Code, Transaction_Date)
);
--2. Create sequences
drop sequence Account_Seq;
drop sequence Broker_Seq;
drop sequence Investor_Seq;
drop sequence Portfolio_Seq;
create sequence Account_Seq start with 7550 increment by 50 nocache;
create sequence Broker_Seq start with 20 increment by 2 nocache;
create sequence Investor_Seq start with 1020 increment by 5 nocache;
create sequence Portfolio_Seq start with 560 increment by 10 nocache;
commit;

Delete From Transaction;
Delete From Exchange_Stock;
Delete From Broker;
Delete From Stock;
Delete From Exchange;
Delete From Portfolio;
Delete From Investor;
Delete From Account;

-- Account
INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7400, 729183);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7050, 761943);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7200, 973128);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7500, 359170);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7250, 164937);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7300, 829371);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7350, 248631);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7100, 462851);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7450, 509374);

INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7150, 1500073);
  
INSERT INTO Account
	(Account_Number, Account_Balance)
VALUES
	(7999, 1500073);

-- Investor

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1008, 'Teagan', 'Hobbs', '1313 Mocking Bird St', 'Edmonton', 'AB', 'T5R 1Q2', 780, 4737711, 'sagittis.@sprint.com', 7350);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1002, 'Penelope', 'Morales', '19 Maple St', 'St. George', 'BC', 'B5T 6Y7', 604, 7894561, 'fermentum@sprint.com', 7250);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1004, 'Tobias', 'Schneider', '10222 102 ST', 'Edmonton', 'AB', 'T5P 1W1', 780, 4997766, 'pellentesque@freenet.com', 7200);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1003, 'Axel', 'Munoz', '1707 3rd Ave', 'Scarsdale', 'NY', '60609', 206, 3512648, 'hendrerit@sprint.com', 7450);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1007, 'Jackson', 'Morton', '15 Elm Road', 'Victoria', 'BC', 'V6T 7U8', 604, 2123636, 'swifty@sprint.com', 7100);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1005, 'Tamerah', 'Berger', '123 195 AVE N.E.', 'Calgary', 'AB', 'T2Y 4R5', 403, 2651234, 'lorem@ipsum.net', 7050);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1001, 'Mary', 'Stanton', '9606 134 Ave', 'Edmonton', 'AB', 'T5Z 3U4', 780, 4655444, 'aliquam@aonet.com', 7300);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1006, 'Britanney', 'Stark', '10110 101 ST N.E.', 'Calgary', 'AB', 'T2C 3E4', 403, 2555666, 'magna@home.com', 7400);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1000, 'Linda', 'Wheeler', '300 Oak St', 'Three Hills', 'AB', 'T1P 2T0', 780, 5565666, 'wheels@sprint.com', 7500);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1009, 'Henry', 'Nguyen', '15 Red Road', 'Red Deer', 'AB', 'T5Y 7U7', 403, 3356689, 'feugiat@city.com', 7150);

INSERT INTO Investor
	(Investor_Number, First_Name, Last_Name, Street_Address, City, Province, Postal_Code, Area_Code, Phone_Number, Email_Address, Account_Number)
VALUES
	(1010, 'Alexis', 'Beasley', '15 Blue Road', 'Edmonton', 'AB', 'T5Y 7U7', 780, 4356689, 'tristique@citycom.com', 7150);

-- Exchange

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('TSX', 'Toronto Stock Exchange', 'Canada');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('SSE', 'Shenzhen Stock Exchange', 'China');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('ASX', 'Northern Territories Stock Exchange', 'Australia');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('JSE', 'Jakarta Stock Exchange', 'Indonesia');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('NYSE', 'New York Stock Exchange', 'U.S.A.');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('HKE', 'Hong Kong Exchanges and Clearing', 'Hong Kong');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('ENB', 'Euronext Brussels', 'Belgium');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('OSE', 'Osaka Securities Exchange', 'Japan');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('LON', 'London Stock Exchange', 'England');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('MSE', 'Maltese Stock Exchange', 'Malta');

INSERT INTO Exchange
	(Exchange_Code, Description, Country)
VALUES
	('FRK', 'Frankfurt Exchange', 'Germany');

-- Broker

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(9, 'Charlie', 'Watts', 780, 5245868, 'sticksandstones@uk.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(6, 'Tina', 'Turner', 403, 2468524, 'nutbush@city.limits');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(4, 'Bob', 'Seger', 604, 6617841, 'nightmoves@detroit.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(1, 'Dennis', 'DeYoung', 403, 9896541, 'styx@sailaway.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(7, 'Charlie', 'Parker', 613, 9645877, 'bird@usa.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(3, 'Aretha', 'Franklin', 100, 2335698, 'respect@detroit.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(5, 'Ruthie', 'Foster ', 880, 1234567, 'joy@blues.usa.com');

INSERT INTO Broker
	(Broker_Number, First_Name, Last_Name, Area_Code, Phone_Number, Email_Address)
VALUES
	(2, 'Joni', 'Mitchell', 780, 5433550, 'bothsides@now.ca');

-- Stock

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('OZZ', 'Deep Maroon Ltd.');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('IBM', 'International Business Machines');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('HON', 'Honeywell International');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('ITTM', 'Itty Bitty Mining');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('GEA01', 'General Electric, Class A1');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('GEA02', 'General Electric, Class A2');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('MEZ', 'Frankfurt Automotive');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('GM', 'General Motors');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('FORD', 'General Salvage');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('RRV', 'Mopar Inc.');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('DIAM1', 'Quality First Diamond Mines');

INSERT INTO Stock
	(Stock_Code, Stock_Name)
VALUES
	('OILY', 'International Oil of Yemen');

-- Exchange_Stock

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('LON', 'IBM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'IBM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'HON', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('OSE', 'RRV', 'N');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('NYSE', 'ITTM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('NYSE', 'IBM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('MSE', 'GEA01', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('FRK', 'MEZ', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('FRK', 'RRV', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('NYSE', 'FORD', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('ASX', 'OILY', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('HKE', 'GM', 'N');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('MSE', 'GM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'ITTM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('ASX', 'DIAM1', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'GEA02', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('MSE', 'IBM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('MSE', 'GEA02', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('MSE', 'HON', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'GEA01', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('JSE', 'GM', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('JSE', 'FORD', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('TSX', 'RRV', 'Y');

INSERT INTO Exchange_Stock
	(Exchange_Code, Stock_Code, Active_YN)
VALUES
	('ASX', 'FORD', 'Y');

-- Portfolio

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(505, 1001, 'International');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(510, 1002, 'National');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(550, 1010, 'Non-RSP');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(515, 1004, 'RSP');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(530, 1007, 'Japan');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(520, 1005, 'RSP');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(500, 1000, 'RSP');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(525, 1006, 'Metals');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(535, 1008, 'Euro');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(540, 1009, 'RSP');

INSERT INTO Portfolio
	(Portfolio_Number, Investor_Number, Portfolio_Description)
VALUES
	(545, 1010, 'Spousal-RSP');

-- Transaction

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(545, To_Date('06-Sep-2018 17:46:11', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 2, 'B', 15, 10.00);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('06-Sep-2018 08:35:55', 'DD-Mon-YYYY HH24:MI:SS'), 'MEZ', 'ENB', 4, 'B', 1750, 33.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('05-Sep-2018 08:08:26', 'DD-Mon-YYYY HH24:MI:SS'), 'MEZ', 'ENB', 4, 'B', 50, 26.70);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('18-Aug-2018 18:02:43', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 4, 'S', 400, 86.75);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('04-Sep-2018 18:32:35', 'DD-Mon-YYYY HH24:MI:SS'), 'GM', 'JSE', 4, 'S', 100000, 52.20);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('08-Aug-2018 18:19:39', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'OSE', 2, 'B', 500, 76.85);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(540, To_Date('06-Sep-2018 17:29:09', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 4, 'S', 1500, 84.20);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('30-Aug-2018 09:27:19', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'NYSE', 2, 'S', 100, 82.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('13-Aug-2018 13:55:06', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'TSX', 2, 'B', 50, 51.25);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('06-Sep-2018 12:28:09', 'DD-Mon-YYYY HH24:MI:SS'), 'ITTM', 'TSX', 4, 'B', 2000, 1.30);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(510, To_Date('13-Aug-2018 19:57:26', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'NYSE', 2, 'B', 25, 86.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('30-Aug-2018 15:32:53', 'DD-Mon-YYYY HH24:MI:SS'), 'ITTM', 'TSX', 1, 'S', 1000, 1.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('22-Aug-2018 16:52:19', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA01', 'OSE', 7, 'B', 210, 32.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('25-Aug-2018 19:23:32', 'DD-Mon-YYYY HH24:MI:SS'), 'DIAM1', 'ASX', 2, 'B', 100, 0.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(510, To_Date('13-Aug-2018 17:22:38', 'DD-Mon-YYYY HH24:MI:SS'), 'OILY', 'ASX', 6, 'B', 1500, 7.50);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('30-Aug-2018 18:46:09', 'DD-Mon-YYYY HH24:MI:SS'), 'MEZ', 'ENB', 4, 'B', 200, 32.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('26-Aug-2018 10:57:24', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'OSE', 7, 'B', 100, 78.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('05-Sep-2018 11:03:23', 'DD-Mon-YYYY HH24:MI:SS'), 'DIAM1', 'ASX', 2, 'B', 25000, 0.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(550, To_Date('06-Sep-2018 14:16:33', 'DD-Mon-YYYY HH24:MI:SS'), 'FORD', 'ASX', 2, 'B', 10, 19.00);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(525, To_Date('30-Aug-2018 15:27:11', 'DD-Mon-YYYY HH24:MI:SS'), 'DIAM1', 'ASX', 6, 'B', 5000, 0.55);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('28-Aug-2018 17:25:46', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'OSE', 7, 'B', 100, 75.70);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('30-Aug-2018 16:48:39', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA02', 'OSE', 7, 'B', 100, 19.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('07-Sep-2018 08:41:22', 'DD-Mon-YYYY HH24:MI:SS'), 'DIAM1', 'ASX', 2, 'S', 100, 0.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('24-Aug-2018 19:41:49', 'DD-Mon-YYYY HH24:MI:SS'), 'ITTM', 'TSX', 1, 'B', 1000, 1.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(550, To_Date('06-Sep-2018 18:46:55', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'TSX', 2, 'S', 100, 23.00);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(505, To_Date('11-Aug-2018 12:16:48', 'DD-Mon-YYYY HH24:MI:SS'), 'FORD', 'NYSE', 5, 'B', 200, 32.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(540, To_Date('06-Sep-2018 16:40:55', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'TSX', 4, 'B', 1000, 42.55);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('03-Sep-2018 20:24:41', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA01', 'TSX', 1, 'B', 300, 36.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('04-Sep-2018 16:26:29', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 4, 'B', 50, 75.00);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('07-Sep-2018 11:57:10', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 4, 'S', 50, 92.85);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(510, To_Date('15-Aug-2018 18:31:58', 'DD-Mon-YYYY HH24:MI:SS'), 'FORD', 'NYSE', 5, 'B', 325, 12.85);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('20-Aug-2018 17:48:12', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'TSX', 1, 'B', 60, 36.85);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('04-Sep-2018 15:29:56', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'OSE', 7, 'B', 100, 89.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('01-Sep-2018 18:39:48', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'OSE', 7, 'B', 270, 39.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('02-Sep-2018 12:10:14', 'DD-Mon-YYYY HH24:MI:SS'), 'HON', 'OSE', 7, 'S', 1700, 39.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('04-Sep-2018 15:47:46', 'DD-Mon-YYYY HH24:MI:SS'), 'OILY', 'ASX', 2, 'B', 1500, 9.85);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(510, To_Date('07-Sep-2018 16:52:27', 'DD-Mon-YYYY HH24:MI:SS'), 'FORD', 'NYSE', 5, 'S', 200, 13.05);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(510, To_Date('12-Aug-2018 11:54:28', 'DD-Mon-YYYY HH24:MI:SS'), 'RRV', 'ENB', 4, 'B', 10000, 0.60);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('05-Sep-2018 09:58:47', 'DD-Mon-YYYY HH24:MI:SS'), 'RRV', 'TSX', 4, 'B', 10000, 1.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('03-Sep-2018 15:24:52', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA02', 'TSX', 1, 'S', 350, 17.10);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('18-Aug-2018 16:39:59', 'DD-Mon-YYYY HH24:MI:SS'), 'GM', 'OSE', 6, 'B', 14, 42.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(535, To_Date('04-Sep-2018 16:06:40', 'DD-Mon-YYYY HH24:MI:SS'), 'FORD', 'JSE', 4, 'B', 525, 10.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(545, To_Date('06-Sep-2018 08:03:49', 'DD-Mon-YYYY HH24:MI:SS'), 'OILY', 'ASX', 2, 'B', 15000, 8.55);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(515, To_Date('23-Aug-2018 13:53:44', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA02', 'TSX', 1, 'B', 250, 12.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('29-Aug-2018 10:32:52', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'OSE', 7, 'S', 2000, 84.35);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(500, To_Date('24-Aug-2018 15:34:55', 'DD-Mon-YYYY HH24:MI:SS'), 'ITTM', 'NYSE', 5, 'B', 1000, 2.15);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(520, To_Date('07-Sep-2018 14:02:48', 'DD-Mon-YYYY HH24:MI:SS'), 'IBM', 'TSX', 4, 'B', 1000, 88.25);

INSERT INTO Transaction
	(Portfolio_Number, Transaction_Date, Stock_Code, Exchange_Code, Broker_Number, Buy_Sell, Quantity, Price_Per_Share)
VALUES
	(530, To_Date('01-Sep-2018 11:23:52', 'DD-Mon-YYYY HH24:MI:SS'), 'GEA02', 'TSX', 7, 'B', 250, 25.30);
commit;
