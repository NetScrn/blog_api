# README
## Разработчик №1
1. Странная архитектура сервисных классов – почему-то валидация происходит в билдере и потом создается либо объект в одном варианте, либо в другом. По сути это 2 абсолютно разных объекта, которые зачем-то засунуты в один класс. Почему нельзя было просто создать объект и сделать чтобы он потом сам себя валидировал – загадка.
2. Расчет рейтинга сделан очень странно – почему-то сам расчет происходит в контроллере, а апдейт – в бекграунде (для чего – непонятно). При большом количестве параллельных запросов у нас не всегда будет самое актуальное значение среднего рейтинга в базе.
3. Сокращение ave вместо avg выносит мозг.
4. Для чего запилены метод Post.reset_all_ave_cache – непонятно. Также непонятно для чего запилен дефолтный режим работы Post.top_ave (который не юзает индекс).
5. Запрос на пересекающиеся айпишники будет неизбежно тормозить при большом количестве данных. Метод Post.ips_used_by_multiple_users к слову вообще падает с ошибкой, как и спеки на него)))
6. Нет задания по SQL.

---

1. ✓

2. ✓ job removed

3. sorry

4. query removed

5. Отдельнная таблица возвращает список за ~90мс, первый вариант занимал ~230ms,
вероятно всеровно медленно, если ip должен остаться даже после удаления поста, можно былобы создать отжельюную таблцу куда бы зписывались ип-логины, и бытсро доставались.
(не написал _spec.rb в конце спека и незаметил что он падает после изменений, когда выполнял `rspec`)

6. todo


## Разработчик №2
1. Самописные валидации, хотя можно применить рельсовые
2. Неоптимально сделано обновление рейтинга, при большом количестве запросов, очередь заполнится, лучше сделать без джобы вообще.
3. спек на апдейт рейтинга не работает, то есть джоба должна сама инлайном выполняться, а не дергаться хелпером
4. зато есть спек на джобу, но он не проверяет, как она работает
5. спека на апишки вообще нет (есть но не работает)
6. запрос с подзапросом мог бы достать сразу все что надо TOP_AVE_POSTS_QUERY
7. запрос IPS_USED_BY_MULTIPLE_USERS_QUERY мог бы иметь в хевинге count(*)>1
8. Логику аггрегации данных по постам можно было бы поместить в сервис, а в модели оставить только то, что связано с постом

---

1. include ActiveModel::Validations - показалось избыточным
> В коде желательно не использовать рельсовых антипаттернов типа колбеков и валидаций в моделях

2. job removed

3. job removed

4. job removed

5. не написал _spec.rb в конце спека и незаметил что он падает после изменений, когда выполнял `rspec`

6. query removed

7. ✓

8. ✓

## SQL

`SELECT
   group_id, 
   count(*) count, 
   min(users.id) min_user_id_in_group
 FROM users
 GROUP BY group_id
 ORDER BY group_id;`
 
 Непонял что занчит: выделить непрерывные группы по group_id с учетом указанного порядка записей (их 4)
 
 