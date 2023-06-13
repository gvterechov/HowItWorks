# frozen_string_literal: true

class WordsOrder::GiveTask
  def call(used_tasks)
    # Если задачи закончились, удаляем самую первую выданную задачу
    used_tasks.shift(used_tasks.count - tasks.count) if used_tasks.count > tasks.count
    # Находим новую еще не выданную задачу
    new_task_index = nil
    tasks.count.times do
      new_task_index = rand(0...tasks.count)
      break if used_tasks.exclude?(tasks[new_task_index][:id])
    end
    tasks[new_task_index]
  end

  private

    def tasks
      # [beautiful_books, cod_sellers, amazing_sellers, japanese_car, young_woman, amazingly_sellers, amazingly_smart,
      #  silver_necklace, yellow_car, red_coat, ceramic_accessories, purple_carpet, coffee_mug, velvet_dress,
      #  entertaining_novelties, tin_box, black_car, mash_soup, yellow_curtains, young_man, old_man]
      [beautiful_books, cod_sellers, japanese_car, young_woman, amazingly_sellers, amazingly_smart,
       silver_necklace, yellow_car, red_coat, ceramic_accessories, purple_carpet, coffee_mug, velvet_dress,
       entertaining_novelties, tin_box, black_car, mash_soup, yellow_curtains, young_man, old_man]
    end

    # The beautiful books
    def beautiful_books
      {
        "id": 1,
        "assignment": {
          "ru": 'Составьте фразу, о красивых книгах',
          "en": 'Make a phrase about beautiful books'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "books"
          }
        ],
        "wordsToSelect": ["beautiful", "The"],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\n# det wrong order\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"beautiful\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:DET ;\n    rdfs:label \"The\" ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"books\" .\n    ",
        "errors": []
      }.with_indifferent_access
    end

    # Japanese salt-cod sellers
    def cod_sellers
      {
        "id": 2,
        "assignment": {
          "ru": 'Составьте фразу, в которой Японские продавцы торгуют соленой селедкой',
          "en": 'Make a phrase where Japanese sellers sell salt cod'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "sellers"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n           rdfs:label \"Japanese\" ;\n           ns1:hasHypernym ns1:Origin ;\n           ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ  ;\n           rdfs:label \"salt\" ;\n           ns1:hasHypernym ns1:Material  ;\n           ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:ADJ ;\n           rdfs:label \"cod\" ;\n           ns1:hasHypernym ns1:Material  ;\n           ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n           rdfs:label \"sellers\" .",
        "wordsToSelect": ["salt", "Japanese", "cod", "-"],
        "errors": []
      }.with_indifferent_access
    end

    # amazing young amazing-salt-cod sellers
    def amazing_sellers
      {
        "id": 3,
        "assignment": {
          "ru": 'Составьте фразу, в которой есть потрясающие молодые продавцы восхитительной соленой селедки',
          "en": 'Make a phrase where sellers are young and amazing and sell amazing salt cod'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_7",
            "name": "sellers"
          }
        ],
        "taskInTTLFormat": "@prefix ns1:  <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>  .\n\nns1:item_0\n    a               ns1:ADJ ;\n    rdfs:label      \"amazing \" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild     ns1:item_7 .\n\nns1:item_1\n    a               ns1:ADJ ;\n    rdfs:label      \"young \" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild     ns1:item_7 .\n\nns1:item_2\n    a               ns1:ADJ ;\n    rdfs:label      \"amazing \" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild     ns1:item_4 .\n\nns1:item_4\n    a               ns1:ADJ ;\n    rdfs:label      \"salt \" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild     ns1:item_6 .\n\nns1:item_7\n    a          ns1:NOUN ;\n    rdfs:label \"sellers \" .\n\nns1:item_6\n    a               ns1:ADJ ;\n    rdfs:label      \"cod \" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild     ns1:item_7 .",
        "wordsToSelect": ["amazing", "young", "amazing", "salt", "cod", "-"]
      }.with_indifferent_access
    end

    # The beautiful Japanese car
    def japanese_car
      {
        "id": 4,
        "assignment": {
          "ru": 'Составьте фразу про красивую японскую машину',
          "en": 'Make a phrase about beautiful car that is Japanese'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "car"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"The\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"beautiful\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"Japanese\" ;\n    ns1:hasHypernym ns1:Origin ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"car\" .",
        "wordsToSelect": ["Japanese", "The", "beautiful"]
      }.with_indifferent_access
    end

    # Beautiful young Russian hammering woman
    def young_woman
      {
        "id": 5,
        "assignment": {
          "ru": 'Составьте фразу про молодую красивую женщину из России, которая умеет забивать гвозди',
          "en": 'Make a phrase about beautiful woman from Russia who are young and able to hammer'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_4",
            "name": "woman"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"Beautiful\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"young\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"Russian\" ;\n    ns1:hasHypernym ns1:Origin ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_3 a ns1:ADJ ;\n    rdfs:label \"hammering\" ;\n    ns1:hasHypernym ns1:Purpose ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_4 a ns1:NOUN ;\n    rdfs:label \"woman\" .",
        "wordsToSelect": ["Beautiful", "Russian", "hammering", "young"]
      }.with_indifferent_access
    end

    # salt-cod amazingly-red sellers
    def amazingly_sellers
      {
        "id": 6,
        "assignment": {
          "ru": 'Составьте фразу про удивительно красных продавцов соленой селедки',
          "en": 'Make a phrase about amazingly red sellers that sell salt cod'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_6",
            "name": "sellers"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"salt\" ;\n            ns1:hasHypernym ns1:Material ;\nns1:isChild ns1:item_2 .\n\nns1:item_3 a ns1:ADJ ;\n    rdfs:label \"amazingly\" ;\n            ns1:hasHypernym ns1:Opinion ;\nns1:isChild ns1:item_5 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"cod\" ;\n        ns1:hasHypernym ns1:Material ;\nns1:isChild ns1:item_6 .\n\nns1:item_5 a ns1:ADJ ;\n    rdfs:label \"red\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_6 .\n\nns1:item_6 a ns1:NOUN ;\n    rdfs:label \"sellers\" .\n",
        "wordsToSelect": ["salt", "-", "cod", "amazingly", "red"]
      }.with_indifferent_access
    end

    # amazingly-smart salt-cod sellers
    def amazingly_smart
      {
        "id": 7,
        "assignment": {
          "ru": 'Составьте фразу про удивительно умных продавцов соленой селедки',
          "en": 'Make a phrase about sellers who sell salt cod and are amazigly smart'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_6",
            "name": "sellers"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"amazingly\" ;\n        ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_3 a ns1:ADJ ;\n    rdfs:label \"salt\" ;\n            ns1:hasHypernym ns1:Material ;\nns1:isChild ns1:item_5 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"smart\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_6 .\n\nns1:item_5 a ns1:ADJ ;\n    rdfs:label \"cod\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_6 .\n\nns1:item_6 a ns1:NOUN ;\n    rdfs:label \"sellers\" .",
        "wordsToSelect": ["salt", "-", "cod", "amazingly", "smart"]
      }.with_indifferent_access
    end

    # ---
    # favorite Mexican silver necklace
    def silver_necklace
      {
        "id": 8,
        "assignment": {
          "ru": 'Составьте фразу про любимое ожерелье из Мексики, изготовленное из серебра',
          "en": 'Make a phrase about favorite necklace from Mexica that is silver'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "necklace"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"silver\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"Mexican\" ;\n    ns1:hasHypernym ns1:Origin ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"favorite\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"necklace\" .",
        "wordsToSelect": ["silver", "Mexican", "favorite"]
      }
    end

    # the new yellow car
    def yellow_car
      {
        "id": 9,
        "assignment": {
          "ru": 'Составьте фразу про новую машину желтого цвета',
          "en": 'Make a phrase about car that is new and yellow'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "car"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"the\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"yellow\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"new\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"car\" .\n",
        "wordsToSelect": ["the", "new", "yellow"]
      }
    end

    # amazing red coat
    def red_coat
      {
        "id": 10,
        "assignment": {
          "ru": 'Составьте фразу про красное и удивительное пальто',
          "en": 'Make a phrase about coat that is red and amazing'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "coat"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"amazing\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"red\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"coat\" .",
        "wordsToSelect": ["amazing", "red"]
      }
    end

    # beautiful ceramic accessories
    def ceramic_accessories
      {
        "id": 11,
        "assignment": {
          "ru": 'Составьте фразу про красивые аксессуары из керамики',
          "en": 'Make a phrase about ceramic accessories that are beautiful'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "accessories"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"beautiful\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"ceramic\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"accessories\" .",
        "wordsToSelect": ["beautiful", "ceramic"]
      }
    end

    # his wool purple carpet
    def purple_carpet
      {
        "id": 12,
        "assignment": {
          "ru": 'Составьте фразу про его фиолетовый ковер из шерсти',
          "en": 'Make a phrase about his purple carpet made of wool'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "carpet"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"his\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"wool\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"purple\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"carpet\" .\n",
        "wordsToSelect": ["his", "wool", "purple"]
      }
    end

    # a lovely old ceramic coffee mug
    def coffee_mug
      {
        "id": 13,
        "assignment": {
          "ru": 'Составьте фразу про милую кружку для кофе из керамики, которая старая',
          "en": 'Make a phrase about a lovely mug for coffe made of ceramic that is old'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_5",
            "name": "mug"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"a\" ;\n    ns1:isChild ns1:item_5 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"lovely\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_5 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"old\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_5 .\n\nns1:item_3 a ns1:ADJ ;\n    rdfs:label \"ceramic\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_5 .\n\nns1:item_4 a ns1:ADJ ;\n    rdfs:label \"coffee\" ;\n    ns1:hasHypernym ns1:Type ;\n    ns1:isChild ns1:item_5 .\n\nns1:item_5 a ns1:NOUN ;\n    rdfs:label \"mug\" .\n",
        "wordsToSelect": ["a", "lovely", "old", "ceramic", "coffee"]
      }
    end

    # a comfortable new velvet dress
    def velvet_dress
      {
        "id": 14,
        "assignment": {
          "ru": 'Составьте фразу про удобное платье из вельвета, которое новое',
          "en": 'Make a phrase about comfortable dress that is new and velvet'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_4",
            "name": "dress"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"a\" ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"comfortable\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"new\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_3 a ns1:ADJ ;\n    rdfs:label \"velvet\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_4 .\n\nns1:item_4 a ns1:NOUN ;\n    rdfs:label \"dress\" .",
        "wordsToSelect": ["a", "comfortable", "new", "velvet"]
      }
    end

    # entertaining Russian novelties
    def entertaining_novelties
      {
        "id": 15,
        "assignment": {
          "ru": 'Составьте фразу про занимательные товары из России',
          "en": 'Make a phrase about entertaining novelties from Russia'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "novelties"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"entertaining\" ;\n    ns1:hasHypernym ns1:Purpose ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"Russian\" ;\n    ns1:hasHypernym ns1:Origin ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"novelties\" .\n",
        "wordsToSelect": ["entertaining", "Russian"]
      }
    end

    # little tin box
    def tin_box
      {
        "id": 16,
        "assignment": {
          "ru": 'Составьте фразу про маленькую коробку из жести',
          "en": 'Make a phrase about little box made of tin'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "box"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"little\" ;\n    ns1:hasHypernym ns1:Size ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"tin\" ;\n    ns1:hasHypernym ns1:Material ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"box\" .\n",
        "wordsToSelect": ["little", "tin"]
      }
    end

    # a big black car
    def black_car
      {
        "id": 17,
        "assignment": {
          "ru": 'Составьте фразу про большую машину черного цвета',
          "en": 'Make a phrase about a big car that is black colored'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "car"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"a\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"big\" ;\n    ns1:hasHypernym ns1:Size ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"black\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"car\" .",
        "wordsToSelect": ["a", "big", "black"]
      }
    end

    # nice mash soup
    def mash_soup
      {
        "id": 18,
        "assignment": {
          "ru": 'Составьте фразу про хороший суп-пюре',
          "en": 'Make a phrase about mash soup that is nice'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "soup"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"nice\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"mash\" ;\n    ns1:hasHypernym ns1:PhysicalQuality ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"soup\" .\n",
        "wordsToSelect": ["nice", "mash"]
      }
    end

    # those horrible yellow curtains
    def yellow_curtains
      {
        "id": 19,
        "assignment": {
          "ru": 'Составьте фразу про эти ужасные шторы желтого цвета',
          "en": 'Make a phrase about those curtains that are horrible and yellow colored'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "curtains"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"those\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"horrible\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"yellow\" ;\n    ns1:hasHypernym ns1:Colour ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"curtains\" .\n",
        "wordsToSelect": ["those", "horrible", "yellow"]
      }
    end

    # a handsome young man
    def young_man
      {
        "id": 20,
        "assignment": {
          "ru": 'Составьте фразу про молодого мужчину, который красив',
          "en": 'Make a phrase about young man that is handsome'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_3",
            "name": "man"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:DET ;\n    rdfs:label \"a\" ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"handsome\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_2 a ns1:ADJ ;\n    rdfs:label \"young\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_3 .\n\nns1:item_3 a ns1:NOUN ;\n    rdfs:label \"man\" .\n",
        "wordsToSelect": ["a", "handsome", "young"]
      }
    end

    # smart old man
    def old_man
      {
        "id": 21,
        "assignment": {
          "ru": 'Составьте фразу про пожилого мужчину, который умен',
          "en": 'Make a phrase about old man that is smart'
        },
        "lang": 1,
        "studentAnswer": [
          {
            "id": "item_2",
            "name": "man"
          }
        ],
        "taskInTTLFormat": "@prefix ns1: <http://www.vstu.ru/poas/code#> .\n@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\nns1:item_0 a ns1:ADJ ;\n    rdfs:label \"smart\" ;\n    ns1:hasHypernym ns1:Opinion ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_1 a ns1:ADJ ;\n    rdfs:label \"old\" ;\n    ns1:hasHypernym ns1:Age ;\n    ns1:isChild ns1:item_2 .\n\nns1:item_2 a ns1:NOUN ;\n    rdfs:label \"man\" .",
        "wordsToSelect": ["smart", "old"]
      }
    end
end
