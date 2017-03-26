## Система для резервирования столов в ресторанах

#### Создание пользователя
```
> User.create!(name: "VitaHub")
=> #<User id: 3, name: "VitaHub", ... >
```

#### Создание ресторана
```
> Restaurant.create!(name: "V")
=> #<Restaurant id: 2, name: "V", ... > 
```

#### Создание расписания ресторана
В качестве значения для поля "day" можно использовать день недели или дату.
```
> r = Restaurant.find_by(name: "V")
=> #<Restaurant id: 2, name: "V", ... >
> r.schedules.create!(day: "Tue, Wed, Thu", time_from: "11:00", time_till: "23:00")
=> #<Schedule id: 2, restaurant_id: 2, day: "Tue, Wed, Thu", time_from: "11:00", time_till: "23:00", ... >
> r.schedules.create!(day: "Fri, Sat, Sun", time_from: "11:00", time_till: "01:00")
=> #<Schedule id: 3, restaurant_id: 2, day: "Fri, Sat, Sun", time_from: "11:00", time_till: "01:00", ... > 
> r.schedules.create!(day: "2017-12-31", time_from: "15:00", time_till: "06:00")
=> #<Schedule id: 4, restaurant_id: 2, day: "2017-12-31", time_from: "15:00", time_till: "06:00", ... >
```

#### Добавление столов к ресторану
```
> r = Restaurant.find_by(name: "V")
=> #<Restaurant id: 2, name: "V", ... >
> r.tables.create!(name: "1")
=> #<Table id: 2, name: "1", restaurant_id: 2, ... >
> r.tables.create!(name: "2")
=> #<Table id: 3, name: "2", restaurant_id: 2, ... >
> r.tables.create!(name: "VIP")
=> #<Table id: 4, name: "VIP", restaurant_id: 2, ... >
```

#### Резервирование столика в ресторане
```
> Reservation.create!(user_id: 3, restaurant_id: 2, table_id: 4, date: Date.parse("2017-03-28"), time: "20:00", duration: "90")
=> #<Reservation id: 8, restaurant_id: 2, table_id: 4, user_id: 3, date: "2017-03-28", time: "20:00", duration: "90", ... >
```
Нельзя зарезервировать столик на уже занятое время:
```
> Reservation.create!(user_id: 3, restaurant_id: 2, table_id: 4, date: Date.parse("2017-03-28"), time: "21:00", duration: "60")
=> ActiveRecord::RecordInvalid: Validation failed: Time This table is already reserved at 21:00 - 21:30.
```
Нельзя зарезервировать столи в день, когда ресторан не работает ("2017-03-27" - Понедельник):
```
> Reservation.create!(user_id: 3, restaurant_id: 2, table_id: 4, date: Date.parse("2017-03-27"), time: "21:00", duration: "60")
=> ActiveRecord::RecordInvalid: Validation failed: Date The restaurant 'V' does not work this day.
```
Нельзя зерезервировать столик в нерабочее время:
```
> Reservation.create!(user_id: 3, restaurant_id: 2, table_id: 4, date: Date.parse("2017-03-29"), time: "10:00", duration: "90")
=> ActiveRecord::RecordInvalid: Validation failed: Time The restaurant 'V' does not work at 10:00 - 11:00 this day.
```

#### Вывод свободных столов ресторана в определенный день
```
> r = Restaurant.find_by(name: "V")
=> #<Restaurant id: 2, name: "V", ... >
> r.free_tables(Date.parse("2017-03-28"))
=> {"1"=>"11:00 - 23:00", "2"=>"11:00 - 23:00", "VIP"=>"11:00 - 20:00; 21:30 - 23:00"}
> r.free_tables(Date.parse("2017-03-27"))
=> nil
```
Так же можно указывать дату и длительность резервирования
```
> r.free_tables(Date.parse("2017-03-28"), "21:00", "60")
=> {"1"=>"11:00 - 23:00", "2"=>"11:00 - 23:00"}
```