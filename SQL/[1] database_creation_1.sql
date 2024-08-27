----------------------------------------------------------
-- Database Creation: Tables, Constraints, Triggers
----------------------------------------------------------
CREATE TABLE Product (
    product_id int   NOT NULL,
    name varchar(250)   NOT NULL,
    listed_price decimal   NOT NULL,
    category varchar(100)   NOT NULL,
    sub_category varchar(100)   NOT NULL,
    CONSTRAINT pk_Product PRIMARY KEY (
        product_id
     ),
    CONSTRAINT uc_Product_name UNIQUE (
        name
    )
);

CREATE TYPE Gender AS ENUM ('Male','Female');

CREATE TABLE Customer (
    customer_id int   NOT NULL,
    first_name varchar(250)   NOT NULL,
    last_name varchar(250)   NOT NULL,
    gender  Gender NOT NULL,
    birthday date   NULL,
    email varchar(250)   NOT NULL,
    phone varchar(20)   NOT NULL,
    address_id int   NOT NULL,
    is_member boolean   NOT NULL,
    member_id int   NULL,
    registration_date date   NOT NULL,
    last_order_date date DEFAULT NULL,
    total_spent decimal  DEFAULT 0.0 NOT NULL,
    CONSTRAINT pk_Customer PRIMARY KEY (
        customer_id
     )
);

CREATE TABLE Address (
    address_id int   NOT NULL,
	customer_id int NOT NULL,
    address1 varchar(250)   NOT NULL,
    address2 varchar(250)   NULL,
    state varchar(250)   NOT NULL,
    zip_code int   NOT NULL,
    country varchar(250)   NOT NULL,
    CONSTRAINT pk_Address PRIMARY KEY (
        address_id
     )
);

CREATE TYPE Status AS ENUM ('Confirmed','Processed','Shipped','Delivered');

CREATE TABLE Orders (
    order_id int   NOT NULL,
    customer_id int   NOT NULL,
    order_date date   NOT NULL,
    total_amount decimal   NOT NULL,
    status Status   NOT NULL,
    CONSTRAINT pk_Order PRIMARY KEY (
        order_id
     )
);

CREATE TABLE OrderLine (
    order_line_id int   NOT NULL,
    order_id int   NOT NULL,
    product_id int   NOT NULL,
	clothing_size varchar(10) NULL,
	shoe_size int NULL,
    quantity int   NOT NULL,
	unit_price decimal NOT NULL,
	line_total decimal NOT NULL,
    CONSTRAINT pk_OrderLine PRIMARY KEY (
        order_line_id
     )
);

CREATE TYPE M_Level AS ENUM ('Basic','Premium');

CREATE TABLE Membership (
    member_id int   NOT NULL,
	customer_id int NOT NULL,
    member_registration_date date NOT NULL,
    membership_level M_Level  NOT NULL,
    CONSTRAINT pk_Membership PRIMARY KEY (
        member_id
     )
);

CREATE TABLE Campaign (
    campaign_id int   NOT NULL,
    name varchar(250)   NOT NULL,
    start_date date   NOT NULL,
    end_date date   NOT NULL,
    budget decimal   NULL,
    discount decimal   NULL,
    target_audience varchar(250)   NOT NULL,
    objective varchar(250)   NOT NULL,
    CONSTRAINT pk_MarketingCampaign PRIMARY KEY (
        campaign_id
     )
);

CREATE TYPE Cost_Type AS ENUM ('Fixed','Variable');

CREATE TABLE Costs (
    cost_id int   NOT NULL,
    name varchar(250)   NOT NULL,
    type Cost_Type   NOT NULL,
    amount decimal   NOT NULL,
    description varchar(250)   NOT NULL,
	campaign_id int NULL,
    period varchar(250)   NULL,
    month varchar(250)   NULL,
    year int   NOT NULL,
    CONSTRAINT pk_Cost PRIMARY KEY (
        cost_id
     )
);

CREATE OR REPLACE FUNCTION update_total_spent_func()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the total_spent in the customers table
    UPDATE Customer
    SET total_spent = total_spent + NEW.total_amount,
        last_order_date = NEW.order_date
    WHERE customer_id = NEW.customer_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_total_spent
AFTER INSERT ON Orders
FOR EACH ROW
EXECUTE FUNCTION update_total_spent_func();

ALTER TABLE Costs ADD CONSTRAINT fk_Costs_campaign_id FOREIGN KEY(campaign_id)
REFERENCES Campaign (campaign_id);
