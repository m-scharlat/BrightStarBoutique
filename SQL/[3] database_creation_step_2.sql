------RUN AFTER DATA IS IMPORTED------

ALTER TABLE Customer ADD CONSTRAINT fk_Customer_address_id FOREIGN KEY(address_id)
REFERENCES Address (address_id);

ALTER TABLE Customer ADD CONSTRAINT fk_Customer_member_id FOREIGN KEY(member_id)
REFERENCES Membership (member_id);

ALTER TABLE Address ADD CONSTRAINT fk_Address_customer_id FOREIGN KEY(customer_id)
REFERENCES Customer (customer_id);

ALTER TABLE Orders ADD CONSTRAINT fk_Order_customer_id FOREIGN KEY(customer_id)
REFERENCES Customer (customer_id);

ALTER TABLE OrderLine ADD CONSTRAINT fk_OrderLine_order_id FOREIGN KEY(order_id)
REFERENCES Orders (order_id);

ALTER TABLE OrderLine ADD CONSTRAINT fk_OrderLine_product_id FOREIGN KEY(product_id)
REFERENCES Product (product_id);

ALTER TABLE Membership ADD CONSTRAINT fk_Membership_customer_id FOREIGN KEY(customer_id)
REFERENCES Customer (customer_id);
