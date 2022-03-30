USE `<your database name>`;

CREATE TABLE `carwash_list` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(255),
	`owner` varchar(255),
	`isForSale` boolean,
	`price` int(11) NOT NULL,
  `accountMoney` int(11),

	PRIMARY KEY (`id`)
);

INSERT INTO `carwash_list` (name, owner, isForSale, price, accountMoney) VALUES
	('PaletoBay', '', true, 25000, 0),
  ('Sandyshore', '', true, 25000, 0),
  ('MiddleWest', '', true, 25000, 0),
  ('LSWest', '', true, 25000, 0),
  ('LSEast', '', true, 25000, 0),
  ('LSNorth', '', true, 25000, 0),
  ('LSSouth', '', true, 25000, 0)
;
