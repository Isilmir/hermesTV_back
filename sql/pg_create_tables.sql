CREATE SCHEMA hermestv;
CREATE TABLE hermestv.objectTypes(id INT GENERATED ALWAYS AS IDENTITY, name varchar(255), description varchar(255), CONSTRAINT PK_objectTypes PRIMARY KEY (id));
CREATE TABLE hermestv.objects (id int,typeId int not null,active boolean default FALSE not null,qr varchar(4000), CONSTRAINT PK_objects PRIMARY KEY (id,typeId), CONSTRAINT FK_objects_objectTypes FOREIGN KEY (typeId)REFERENCES hermestv.objectTypes (id));


