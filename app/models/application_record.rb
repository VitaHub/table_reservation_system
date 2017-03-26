class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

    # Рабочие часы (получасы): 0.0, 0.5, 1.0, ... , 23.0, 23.5, 0.0, 0.5, ... , 23.5
  WORKING_HOURS = (0..23).to_a.map{|e| [e * 1.0, e+0.5]}.flatten * 2
    # Шаблон для времени: 00:00 00:30 01:00 ... 23:30
  TIME_FORMAT = /[01]\d[.:][03]0|2[0-3][.:][03]0/

  private 

      # Превращает часовой массив [8.5, 9.0, 12.0, 12.5]
      # во временные интервалы в формате строки
      # "08:30 - 09:30; 12:00 - 13:00"
    def arr_to_time(arr, working_time = WORKING_HOURS)
      return nil if arr.empty?
      array = working_time & arr # упорядочивает согласно порядку рабочих часов
      time = "#{num_to_time_str(array[0])} - "
      if array.size == 1 || array[1] - array[0] > 0.5
        time << "#{num_to_time_str(array[0] + 0.5)}; "
      end
      (array.size - 1).times do |i|
        i = i + 1
        if array[i] - array[i-1] != 0.5 && array[i] - array[i-1] != -23.5
          time << "#{num_to_time_str(array[i])} - "
        end
        if i == array.size - 1 || 
           array[i+1] - array[i] > 0.5 ||
           (array[i+1] - array[i] < 0 && array[i+1] - array[i] != -23.5)
          t = array[i] + 0.5
          time << "#{num_to_time_str(t)}; "
        end
      end
      time[0..-3].gsub('24', '00')
    end

      # преобразует число во время в формате строки
      # 3.5 => "03:30"
    def num_to_time_str(num)
      "#{'%02d' % num.to_i}:#{'%02d' % (num%1*60).to_i}"
    end

      # преобразует время в формате строки в число
      # "03:30" => 3.5
    def time_str_to_num(time)
      time[0..1].to_i + time[3..-1].to_i/60.0
    end

      # перевод времени и длительности резервирования в формат массива получасов
      # 19:00, 90 => [19.0, 19.5, 20.0]
    def reservation_time_arr(time, duration)
      time = time_str_to_num(time)
      reservation_time = [time]
      duration = duration.to_i
      (duration / 30 - 1).times do |n|
        reservation_time << time + 0.5 * (n + 1)
      end
      reservation_time
    end
end
