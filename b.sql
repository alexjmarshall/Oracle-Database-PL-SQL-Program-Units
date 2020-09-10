--3. Write a procedure (PR_Q3) that will be used to change all the broker e-mail addresses with a given domain name to a new domain name. The procedure will be passed two strings: i) the original domain name that is to be replaced; and ii) the new domain name that will be replacing the original (in that order). For example, if the procedure is passed the strings "snailmail.com” and "slowpoke.com", every e-mail in the database with "snailmail.com" as their domain name will be changed to "slowpoke.com" as their domain name (e.g. "billy@snailmail.com” will become “billy@ slowpoke.com”). The procedure must ensure that all variations (upper or lower case) of the first string are found and replaced by the second string. Update only those records that need to be updated and only update each record once. Use at least one explicit cursor in your solution.

CREATE OR REPLACE PROCEDURE PR_Q3 (p_OldDomainName varchar2, p_NewDomainName varchar2)
AUTHID CURRENT_USER
IS
CURSOR c_emailAddress IS
  SELECT Broker_Number,Email_Address
  FROM Broker
  WHERE LOWER(Email_Address) LIKE '%@'||LOWER(p_OldDomainName);
v_BrokerNumber Broker.Broker_Number%TYPE;
v_EmailAddress Broker.Email_Address%TYPE;
v_LocalAddress Broker.Email_Address%TYPE;
v_AtPosition number(2,0);
BEGIN
OPEN c_emailAddress;
--start loop to update all email addresses in cursor
  LOOP
    FETCH c_emailAddress INTO v_BrokerNumber,v_EmailAddress;
    EXIT WHEN c_emailAddress%NOTFOUND;
    --find the position of the @ symbol in the email address
    v_AtPosition := INSTR(v_EmailAddress,'@');
    --capture local address up to the @ symbol from the email address
    v_LocalAddress := SUBSTR(v_emailAddress,1,v_AtPosition);
    UPDATE Broker
    SET Email_Address = v_LocalAddress||p_NewDomainName
    WHERE Broker_Number = v_BrokerNumber;
  END LOOP;
--end loop to update all email addresses in cursor
CLOSE c_emailAddress;
END PR_Q3;
/
SHOW ERRORS;

--4. Write an overloaded function (FN_Q4) inside a package (PKG_Q4). This function is passed either: i) a portfolio number and a stock code (in that order); or ii) a portfolio description, an investor number and a stock name (in that order). You can assume that the portfolio and investor input parameters are valid. The function will return a string indicating the weighted average cost of the given stock for the given portfolio. If the stock information is not valid, return an appropriate error message including the invalid input parameter. If the portfolio does not contain the requested stock, the function will return the string "[investor first name] [investor last name] does not have any of the units of the stock [stock name] in the portfolio [portfolio description]”. If the portfolio does contain the stock, the function will return the string "[investor first name] [investor last name] paid, on average, [weighted average] for the stock [stock name] in the portfolio [portfolio description]”. All input parameters will be passed to the function in the correct order. Use exception handling in your solution.
CREATE OR REPLACE PACKAGE PKG_Q4
AUTHID CURRENT_USER
IS
FUNCTION FN_Q4(p_Portfolio_Number number, p_Stock_Code varchar2)
  RETURN varchar2;
FUNCTION FN_Q4(p_Portfolio_Description varchar2, p_Investor_Number number, p_Stock_Name varchar2)
  RETURN varchar2;
END PKG_Q4;
/
SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY PKG_Q4
IS
  FUNCTION FN_Q4(p_Portfolio_Number number, p_Stock_Code varchar2)
  RETURN varchar2
  IS
  v_StockCode Stock.Stock_Code%TYPE;
  v_StockName Stock.Stock_Name%TYPE;
  v_InvestorFirstName Investor.First_Name%TYPE;
  v_InvestorLastName Investor.Last_Name%TYPE;
  v_PortfolioDescription Portfolio.Portfolio_Description%TYPE;
  v_SumPrice number(8,2);
  v_SumQuantity number(9);
  v_wgtAvg Transaction.Price_Per_Share%TYPE;
  v_TransactionRowCount number(5);
  e_StockNotInPortfolio EXCEPTION;
  BEGIN
    --select stock for validation
    SELECT Stock_Code, Stock_Name
    INTO v_StockCode, v_StockName
    FROM Stock
    WHERE UPPER(Stock_Code) = UPPER(p_Stock_Code);
    
    SELECT First_Name, Last_Name, Portfolio_Description
    INTO v_InvestorFirstName, v_InvestorLastName, v_PortfolioDescription
    FROM Investor NATURAL JOIN Portfolio
    WHERE Portfolio_Number = p_Portfolio_Number;
    
    --weighted average = sum(price * qty) /qty. Select sum price and qty for this portfolio/stock combination from transaction
    SELECT NVL(SUM(PRICE_PER_SHARE*QUANTITY),0), NVL(SUM(QUANTITY),0), NVL(COUNT(*),0)
    INTO v_SumPrice, v_SumQuantity, v_TransactionRowCount
    FROM Transaction
    WHERE Portfolio_Number = p_Portfolio_Number AND
          UPPER(Stock_Code) = UPPER(p_Stock_Code) AND
          Buy_Sell = 'B';
          
    --if above select statement produced 0 rows, portfolio/stock combination does not exist
    IF v_TransactionRowCount = 0 THEN
      RAISE e_StockNotInPortfolio;
    ELSE
      v_wgtAvg := v_SumPrice/v_SumQuantity;
      RETURN v_investorFirstName||' '||v_InvestorLastName||' paid, on average, '||LTRIM(TO_CHAR(v_wgtAvg,'$9990.99'))||' for the stock '||v_StockName||' in the portfolio '||v_PortfolioDescription||'.';
    END IF;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 'Stock code '||p_Stock_Code||' was not found.';
      WHEN e_StockNotInPortfolio THEN
        RETURN v_InvestorFirstName||' '||v_InvestorLastName||' does not have any units of the stock '||v_StockName||' in the portfolio '||v_PortfolioDescription||'.';
      WHEN OTHERS THEN
        RETURN 'A very unusual error has occurred in PKG_Q4.FN_Q4('||p_Portfolio_Number||','||p_Stock_Code||'). Please contact tech support immediately.';
  END FN_Q4;

  FUNCTION FN_Q4(p_Portfolio_Description varchar2, p_Investor_Number number, p_Stock_Name varchar2)
  RETURN varchar2
  IS
  v_StockCode Stock.Stock_Code%TYPE;
  v_PortfolioNumber Portfolio.Portfolio_Number%TYPE;
  v_InvestorFirstName Investor.First_Name%TYPE;
  v_InvestorLastName Investor.Last_Name%TYPE;
  v_SumPrice number(8,2);
  v_SumQuantity number(9);
  v_WgtAvg Transaction.Price_Per_Share%TYPE;
  v_StockCodeTooManyRowsFlag boolean := TRUE;
  v_PortDescTooManyRowsFlag boolean := TRUE;
  v_TransactionRowCount number(5);
  e_StockNotInPortfolio EXCEPTION;
  BEGIN
    --select stock information for validation, flag indicates select stock caused too many rows
    SELECT Stock_Code
    INTO v_StockCode
    FROM Stock
    WHERE LOWER(Stock_Name) = LOWER(p_Stock_Name);
    v_StockCodeTooManyRowsFlag := FALSE;
    
    SELECT First_Name, Last_Name
    INTO v_InvestorFirstName, v_InvestorLastName
    FROM Investor
    WHERE Investor_Number = p_Investor_Number;
  
    --select portfolio information for validation, flag indicates select portfolio caused too many rows
    SELECT Portfolio_Number
    INTO v_PortfolioNumber
    FROM Portfolio
    WHERE LOWER(Portfolio_Description) = LOWER(p_Portfolio_Description);
    v_PortDescTooManyRowsFlag := FALSE;
    
    --weighted average = sum(price * qty) /qty. Select sum price and qty for this portfolio/stock combination from transaction
    SELECT NVL(SUM(PRICE_PER_SHARE*QUANTITY),0), NVL(SUM(QUANTITY),0), NVL(COUNT(*),0)
    INTO v_SumPrice, v_SumQuantity, v_TransactionRowCount
    FROM Transaction
    WHERE Portfolio_Number = v_PortfolioNumber AND
          Stock_Code = v_StockCode AND
          Buy_Sell = 'B';

    --if above select statement produced 0 rows, portfolio/stock combination does not exist
    IF v_TransactionRowCount = 0 THEN
      RAISE e_StockNotInPortfolio;
    ELSE
      v_WgtAvg := v_SumPrice/v_SumQuantity;
      RETURN v_InvestorFirstName||' '||v_InvestorLastName||' paid, on average, '||LTRIM(TO_CHAR(v_WgtAvg,'$9990.99'))||' for the stock '||p_Stock_Name||' in the portfolio '||p_Portfolio_Description||'.';
    END IF;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN 'Stock name '||p_Stock_Name||' was not found.';
      WHEN TOO_MANY_ROWS THEN
        IF v_StockCodeTooManyRowsFlag THEN
          RETURN 'Stock name '||p_Stock_Name||' matches too many records.';
        ELSIF v_PortDescTooManyRowsFlag THEN
          RETURN 'Portfolio description '||p_Portfolio_Description||' matches too many records.';
        END IF;
      WHEN e_StockNotInPortfolio THEN
        RETURN v_InvestorFirstName||' '||v_InvestorLastName||' does not have any units of the stock '||p_Stock_Name||' in the portfolio '||p_Portfolio_Description||'.';
      WHEN OTHERS THEN
        RETURN 'A very unusual error has occurred in PKG_Q4.FN_Q4('||p_Portfolio_Description||','||p_Investor_Number||','||p_Stock_Name||'). Please contact tech support immediately.';
        
  END FN_Q4;
END PKG_Q4;
/
SHOW ERRORS;

--5. Write a trigger (TR_Q5) that will ensure the buying and selling of stocks (i.e. insertions into the Transaction table) follows two rules: a) If the transaction is a "sell", the investor must currently own the quantity of the stock that they are trying to sell. b) If the transaction is a "buy", the investor must have enough money to make the purchase. If either of the rules is violated, the user should be notified with an appropriate error message and the processing should be discontinued. Otherwise, update the amount of money in the investor’s account accordingly.
CREATE OR REPLACE TRIGGER TR_Q5
BEFORE INSERT ON transaction
FOR EACH ROW
DECLARE
v_InvestorAccNumber Account.Account_Number%TYPE;
v_InvestorAccNumberNoData boolean := TRUE;
v_SumQuantityBought number(9);
v_SumQuantitySold number(9);
v_PortfolioDescription Portfolio.Portfolio_Description%TYPE;
v_PortfolioDescNoData boolean := TRUE;
v_InvestorAccBalance Account.Account_Balance%TYPE;
v_InvestorAccBalanceNoData boolean := TRUE;
v_InvestorFirstName Investor.First_Name%TYPE;
v_InvestorLastName Investor.Last_Name%TYPE;
v_InvestorNameNoData boolean := TRUE;
e_InsufficientShares EXCEPTION;
e_InsufficientFunds EXCEPTION;
BEGIN
  --select investor account number for validation, flag indicates this select caused no data found
  SELECT Account_Number
  INTO v_InvestorAccNumber
  FROM Investor NATURAL JOIN Portfolio
  WHERE Portfolio_Number = :NEW.Portfolio_Number;
  v_InvestorAccNumberNoData := FALSE;
  
  IF :NEW.Buy_Sell = 'S' THEN
    --if transaction is a sale, find quantity of shares on hand and compare with shares to be sold
    --quantity on hand = quantity bought - quantity sold
    SELECT NVL(SUM(Quantity),0)
    INTO v_SumQuantityBought
    FROM Transaction
    WHERE Portfolio_Number = :NEW.Portfolio_Number AND
          Stock_Code = :NEW.Stock_Code AND
          Buy_Sell = 'B';

    SELECT NVL(SUM(Quantity),0)
    INTO v_SumQuantitySold
    FROM Transaction
    WHERE Portfolio_Number = :NEW.Portfolio_Number AND
          Stock_Code = :NEW.Stock_Code AND
          Buy_Sell = 'S';
    
    --if quantity on hand >= quantity to be sold, allow insert and credit investor account
    IF v_SumQuantityBought - v_SumQuantitySold >= :New.Quantity THEN
      UPDATE Account
      SET Account_Balance = Account_Balance + :NEW.Price_Per_Share * :NEW.Quantity
      WHERE Account_Number = v_InvestorAccNumber;
    ELSE
      --if quantity on hand < quantity to be sold, raise insufficient shares exception
      --select portfolio for validation, flag indicates this select caused no data found
      SELECT Portfolio_Description
      INTO v_PortfolioDescription
      FROM Portfolio
      WHERE Portfolio_Number = :NEW.Portfolio_Number;
      v_PortfolioDescNoData := FALSE;
      RAISE e_InsufficientShares;
    END IF;
  ELSE
    --if transaction is a purchase, find investor account balance and compare with purchase cost
    --select investor account balance for validation, flag indicates this select caused no data found
    SELECT Account_Balance
    INTO v_InvestorAccBalance
    FROM Account
    WHERE Account_Number = v_InvestorAccNumber;
    v_InvestorAccBalanceNoData := FALSE;

    --if account balance >= purchase cost, deduct cost from account
    IF v_InvestorAccBalance >= :NEW.Price_Per_Share * :NEW.Quantity THEN
      UPDATE Account
      SET Account_Balance = Account_Balance - :NEW.Price_Per_Share * :NEW.Quantity
      WHERE Account_Number = v_InvestorAccNumber;
    ELSE
      --if account balance < purchase cost, raise insufficient funds exception
      --select investor name for validation, flag indicates this select caused no data found
      SELECT First_Name, Last_Name
      INTO v_InvestorFirstName, v_InvestorLastName
      FROM Investor NATURAL JOIN Portfolio
      WHERE Portfolio_Number = :NEW.Portfolio_Number;
      v_InvestorNameNoData := FALSE;
      RAISE e_InsufficientFunds;
    END IF;
  END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    IF v_InvestorAccNumberNoData OR v_InvestorAccBalanceNoData THEN
      RAISE_APPLICATION_ERROR(-20004,'No investor account was found associated with the portfolio number '||:NEW.Portfolio_Number||'.');
    ELSIF v_PortfolioDescNoData THEN
      RAISE_APPLICATION_ERROR(-20003,'Portfolio number '||:NEW.Portfolio_Number||' was not found.');
    ELSIF v_InvestorNameNoData THEN
      RAISE_APPLICATION_ERROR(-20005,'No investor was found associated with the portfolio number '||:NEW.Portfolio_Number||'.');
    END IF;
  WHEN e_InsufficientShares THEN
    RAISE_APPLICATION_ERROR(-20001,'The portfolio '||v_PortfolioDescription||' does not have enough shares of '||:NEW.Stock_Code||' to complete this transaction.');
  WHEN e_InsufficientFunds THEN
    RAISE_APPLICATION_ERROR(-20002,v_InvestorFirstName||' '||v_InvestorLastName||' does not have sufficient funds in their account to complete this transaction.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20006,'A very unusual error was found in TRIGGER TR_Q5. Please contact tech support immediately.');
END TR_Q5;
/
SHOW ERRORS;
