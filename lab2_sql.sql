Use Labor_SQL;

-- Вивести інформацію про видачу грошей на суму понад 2000 грн. на пунктах прийому таблиці
-- Outcome_o. Вихідні дані впорядкувати за спаданням за стовпцем date.

select * from Outcome_o where `out`> 2000.00 order by date desc;

-- З таблиці Ships вивести назви кораблів, що мають у своїй назві дві літери 'e'.

select name from Ships where name like '%e%e%';


-- Вкажіть виробника для тих ноутбуків, що мають
-- жорсткий диск об’ємом не менше 10 Гбайт. Вивести: maker, type, speed, hd.

select maker, type, speed, hd from Laptop, Product where hd > 10 and type = 'Laptop';


-- Знайдіть виробників, що випускають ПК, але не ноутбуки (використати операцію IN). Вивести maker.

select maker from Product where type  = 'PC' and  maker NOT IN (select maker from Product where type = 'Laptop') group by maker;

-- Знайдіть виробників, які б випускали ноутбуки зі швидкістю 500 МГц та нижче. Виведіть: maker.

select maker as product_maker from Product as P join Laptop as L on L.model = P.model where speed < 500 group by maker;

-- 6. Для таблиці Outcomes виведіть дані, а замість значень 
-- стовпця result, виведіть еквівалентні їм надписи українською мовою.

select ship,battle, case 
	when result = 'OK' then 'норм' 
    when result =  'sunk' then 'потонув' 
    when result = 'damaged' then 'пошкоджений' 
end as result
from Outcomes;


-- 7. Знайдіть принтери, що мають найвищу ціну. Вивести: model, price.

select model, price from Printer where price =(select max(price) from Printer);

-- 8. Знайдіть мінімальну ціну ПК, що випускаються кожним виробником. Вивести: maker, мінімальна ціна. (Підказка:
-- використовувати підзапити в якості обчислювальних стовпців).

select maker, min(price) from Product join PC on Product.model  = PC.model group by maker; 

-- 9 Визначити назви всіх кораблів із таблиці Ships, які
#задовольняють, у крайньому випадку, комбінації будь-яких чотирьох
# критеріїв із наступного списку: numGuns=12, bore=16,
#displacement=46000, type='bc', country='Gt.Britain', launched=1941,
#class='North Carolina'. Вивести: name, numGuns, bore, displacement,
#type, country, launched, class. (Підказка: використати для перевірки умов оператор CASE)

select name, numGuns, bore, displacement, type, country, launched, Ships.class from Ships join Classes on Ships.class = Classes.class where 
               (case when numGuns=12 then 1 else 0 end +
               case when bore=16 then 1 else 0 end + 
               case when displacement=46000 then 1 else 0 end + 
			   case when type='bc' then 1 else 0 end + 
			   case when country='Gt.Britain'then 1 else 0  end + 
			   case when launched=1941 then 1 else 0  end + 
			   case when  Classes.class='North Carolina' then 1 else 0  end) >= 4 ;
               
          
-- 10 БД «Кораблі». Для кожного класу порахувати кількість кораблів,
-- що входить до нього (врахувати також кораблі в таблиці Outcomes,
-- яких немає в таблиці Ships). Вивести: class, кількість кораблів у класі.
-- (Підказка: використовувати оператор UNION та операцію EXISTS)

select class,(select count(*) from Ships where Ships.class = Classes.class)  as number_of_ships
from Classes where exists(select * from Ships where Ships.class = Classes.class) 
union 
select "Unknown" as class, count(Outcomes.ship) from Outcomes where not exists(select * from Ships  
where Outcomes.ship = Ships.name);