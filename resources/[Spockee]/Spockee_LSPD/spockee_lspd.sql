INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('society_police', 'LSPD', 1),
('society_police_BM-Saisies', 'LSPD', 1);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('society_police', 'LSPD', 1),
('society_police_Frigo', 'LSPD', 1),
('society_police_Saisies', 'LSPD', 1);

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('police', 'LSPD', 1),
('off_police', 'LSPD', 1);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('police', 0, 'cadet', 'Cadet', 75, '{}', '{}'),
('police', 1, 'officer1', 'Officier I', 80, '{}', '{}'),
('police', 2, 'officer2', 'Officier II', 85, '{}', '{}'),
('police', 3, 'officer3', 'Officier III', 90, '{}', '{}'),
('police', 4, 'officer4', 'Officier III+1', 90, '{}', '{}'),
('police', 5, 'sergaent1', 'Sergent I', 100, '{}', '{}'),
('police', 6, 'sergaent2', 'Sergent II', 110, '{}', '{}'),
('police', 7, 'lieutenant1', 'Lieutenant I', 120, '{}', '{}'),
('police', 8, 'lieutenant2', 'Lieutenant II', 130, '{}', '{}'),
('police', 9, 'captain', 'Capitaine', 150, '{}', '{}'),
('police', 10, 'commander', 'Commandant', 170, '{}', '{}'),
('police', 11, 'boss', 'Chef de Police', 190, '{}', '{}');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('off_police', 0, 'cadet', 'Cadet', 75, '{}', '{}'),
('off_police', 1, 'officer1', 'Officier I', 80, '{}', '{}'),
('off_police', 2, 'officer2', 'Officier II', 85, '{}', '{}'),
('off_police', 3, 'officer3', 'Officier III', 90, '{}', '{}'),
('off_police', 4, 'officer4', 'Officier III+1', 90, '{}', '{}'),
('off_police', 5, 'sergaent1', 'Sergent I', 100, '{}', '{}'),
('off_police', 6, 'sergaent2', 'Sergent II', 110, '{}', '{}'),
('off_police', 7, 'lieutenant1', 'Lieutenant I', 120, '{}', '{}'),
('off_police', 8, 'lieutenant2', 'Lieutenant II', 130, '{}', '{}'),
('off_police', 9, 'captain', 'Capitaine', 150, '{}', '{}'),
('off_police', 10, 'commander', 'Commandant', 170, '{}', '{}'),
('off_police', 11, 'boss', 'Chef de Police', 190, '{}', '{}');

ALTER TABLE `users`
	ADD `job_duty` INT(1) NOT NULL DEFAULT '0'
	ADD `gun_license` INT(1) NOT NULL DEFAULT '0'
;