CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    book_name VARCHAR(100),
    author VARCHAR(100),
    price DECIMAL,
    genre_id INT,
    quantity INT,
    publication_year INT,
    FOREIGN KEY (genre_id) REFERENCES BookGenre(genre_id)
);

CREATE TABLE BookAccounting (
    inventory_number INT PRIMARY KEY,  
    book_id INT,                       
    FOREIGN KEY (book_id) REFERENCES Books(book_id) 
);

CREATE TABLE Readers (
    reader_id INT AUTO_INCREMENT PRIMARY KEY,
    reader_name VARCHAR(100),
    date_birth DATE,
    address VARCHAR(100)
);

CREATE TABLE BookMovement(
	reader_id INT,
	inventory_number INT,
	issue_date DATE,
	return_date DATE,
	FOREIGN KEY (reader_id) REFERENCES Readers(reader_id),
	FOREIGN KEY (inventory_number) REFERENCES BookAccounting(inventory_number)
);


CREATE TABLE BookGenre (
	genre_id INT PRIMARY KEY,
	genre VARCHAR(100)

);

INSERT INTO Books (book_id, book_name , author, price, genre_id , Quantity)
VALUES 
(1, 'Кобзар', 'Тарас Шевченко', 1200.00, 1, 5),
(2, 'Тіні забутих предків', 'Михайло Коцюбинський', 800.00, 2, 3),
(3, 'Захар Беркут', 'Іван Франко', 950.00, 1, 4),
(4, 'Лісова пісня', 'Леся Українка', 900.00, 3, 6),
(5, 'Хіба ревуть воли, як ясла повні?', 'Панас Мирний', 850.00, 4, 2),
(6, 'Мойсей', 'Іван Франко', 700.00, 3, 8),
(7, 'Собор', 'Олесь Гончар', 750.00, 2, 10),
(8, 'Вершники', 'Юрій Яновський', 800.00, 4, 7),
(9, 'Чорна рада', 'Пантелеймон Куліш', 600.00, 2, 5),
(10, 'Камінний хрест', 'Василь Стефаник', 700.00, 1, 6);

INSERT INTO BookAccounting (inventory_number, book_id)
VALUES 
(1001, 1),
(1002, 2),
(1003, 3),
(1004, 4),
(1005, 5),
(1006, 6),
(1007, 7),
(1008, 8),
(1009, 9),
(1010, 10);

INSERT INTO Readers (reader_name , date_birth , address)
VALUES 
('Іваненко', '1991-03-12', 'Київ, вул. Хрещатик, 10'),
( 'Шевченко', '1980-07-20', 'Львів, вул. Шевченка, 15'),
('Коваленко', '1975-05-11', 'Одеса, вул. Дерибасівська, 25'),
('Сидоренко', '1985-10-01', 'Дніпро, просп. Яворницького, 7'),
('Петренко', '1990-01-22', 'Харків, вул. Сумська, 18'),
('Мельник', '1987-08-14', 'Запоріжжя, просп. Соборний, 3'),
('Кравчук', '1993-06-30', 'Чернігів, вул. Шевченка, 9'),
('Лисенко', '1992-11-15', 'Івано-Франківськ, вул. Грушевського, 2'),
('Тарасенко', '1983-09-28', 'Черкаси, бул. Шевченка, 30'),
('Захаренко', '1995-02-18', 'Вінниця, вул. Соборна, 45');

INSERT INTO BookMovement (reader_id , inventory_number , issue_date , return_date)
VALUES 
(1, 1002, '2024-04-01', '2024-04-10'),  
(2, 1003, '2024-04-05', '2024-04-15'),  
(3, 1004, '2024-04-10', '2024-04-20'),  
(4, 1005, '2024-04-15', '2024-04-25'),  
(5, 1006, '2024-05-01', '2024-05-10'),  
(6, 1007, '2024-05-05', '2024-05-15'),  
(7, 1008, '2024-05-10', '2024-05-20'),  
(8, 1009, '2024-05-15', '2024-05-25'),  
(9, 1010, '2024-06-01', '2024-06-10'),  
(10, 1001, '2024-06-05', '2024-06-15'), 
(1, 1003, '2024-06-10', '2024-06-20'),  
(2, 1004, '2024-06-15', '2024-06-25'),  
(3, 1005, '2024-06-20', '2024-06-30'),  
(4, 1006, '2024-07-01', '2024-07-10'),  
(5, 1007, '2024-07-05', '2024-07-15');  

INSERT INTO BookGenre (genre_id , genre)
VALUES 
(1, 'Українська класика'),
(2, 'Історична проза'),
(3, 'Поетична лірика'),
(4, 'Соціальна драма'),
(5, 'Фантастика'),
(6, 'Пригодницька література'),
(7, 'Романтика'),
(8, 'Психологічна проза'),
(9, 'Філософські твори'),
(10, 'Публіцистика');

SELECT * 
FROM BookMovement 


ALTER TABLE Books
DROP COLUMN year;


WITH BooksAbove850 AS (
    SELECT 
        r.reader_name, 
        COUNT(bm.inventory_number) AS books_borrowed
    FROM 
        BookMovement bm 
    JOIN 
        Readers r ON bm.reader_id = r.reader_id
    JOIN 
        BookAccounting ba ON bm.inventory_number = ba.inventory_number 
    JOIN 
        Books b ON ba.book_id = b.book_id 
    JOIN 
        BookGenre bg ON b.genre_id = bg.genre_id 
    WHERE 
        b.price > 850
    GROUP BY 
        r.reader_name
),
BooksBelow850 AS (
    SELECT 
        r.reader_name, 
        COUNT(bm.inventory_number) AS books_borrowed
    FROM 
        BookMovement bm 
    JOIN 
        Readers r ON bm.reader_id = r.reader_id
    JOIN 
        BookAccounting ba ON bm.inventory_number = ba.inventory_number 
    JOIN 
        Books b ON ba.book_id = b.book_id 
    JOIN 
        BookGenre bg ON b.genre_id = bg.genre_id 
    WHERE 
        b.price < 850
    GROUP BY 
        r.reader_name
)
SELECT 
    reader_name, 
    books_borrowed
FROM 
    BooksAbove850
UNION
SELECT 
    reader_name, 
    books_borrowed
FROM 
    BooksBelow850
ORDER BY 
    books_borrowed DESC;


   

SELECT 
    b.book_id,                     
    b.book_name,                 
    b.author,                  
    b.price,                     
    bg.genre,                  
    r.reader_name,                   
    bm.issue_date,                
    bm.return_date                 
FROM 
        BookMovement bm 
    JOIN 
        Readers r ON bm.reader_id = r.reader_id
    JOIN 
        BookAccounting ba ON bm.inventory_number = ba.inventory_number 
    JOIN 
        Books b ON ba.book_id = b.book_id 
    JOIN 
        BookGenre bg ON b.genre_id = bg.genre_id 
WHERE 
    b.price > 500.00                                                          
GROUP BY 
    b.book_id,  b.book_name, b.author, b.price, bg.genre, r.reader_name, bm.issue_date, bm.return_date
ORDER BY 
    bm.issue_date DESC                                    
    

