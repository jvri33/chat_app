create_reminder = [
   "Añade una alarma el 5 de octubre a las 7 para ir al medico",
    "Añade un recordatorio para ir al dentista el dia 8",
    "Añade una aviso mañana para hacer la cena",
    "Añade una tarea a las 7 para hacer una videollamada",
    "Avisame hoy a las 7",
    "Avisame el miercoles que viene para ir a comprar a las 5",
    "Avisame el dia 6 de octubre para sacar las entradas",
    "Avisame a las 5 para despertarme de la siesta",
    "Crea una alarma mañana a las 9 de la mañana",
    "Avisa el miercoles para entrenar",
    "poner recordatorio a las 5",
    "añademe una tarea el jueves que viene para hacer deberes",
    "añade un recordatorio el domingo que me voy al campo",
    "programame un aviso pasadomañana a las 3",
    "añademe una tarea para ir al fisio el jueves 29 a las 4",
    "recuerda que vaya a comprar pasta mañana a las 12",
    "añade un recordatorio para hacer la compra el sabado a las 10 de la mañana",
    "recuerdame que vaya a la oficina el miercoles que viene",
    "crea un recordatorio el 15 de abril porque son paellas en alicante",
    "avisar hoy a las 7",
    "recordar mañana que vaya a ver a mi abuela",
    "avisame pasadomañana a las 5 para ir al taller",
    "programa una alarma el sabado a las 8 de la mañana",
    "crear un recordatorio todos los dias durante la semana que viene a las 7 de la tarde",
    "añademe un aviso para hacer la renta mañana ",
    "recuerda que tengo oculista el viernes a las 3 de la tarde",
    "recuerda la reunion mañana a las 10 de la mañana",
    "añade una tarea el jueves 13 para ir a la tienda",
    "avisame para ir al gimnasio mañana a las 18:00",
    "crea una alarma la semana que viene a las 9 todos los días",
    "programame un recordatorio para hacer la compra hoy a las 7",
    "quiero añadir un aviso el martes a las 14:00",
    "avisa para irme a correr a las 8 de la tarde",
    "añademe un aviso el dia 5 a las 3 para ir al hospital",
    "quiero crear una tarea a las 4 el jueves para salir antes de trabajar",
    "añade una alarma pasadomañana a las 6 de la mañana",
    "poner un recordatorio para el dentista el jueves",
    "programa el viernes un aviso para ir a hacerme la analitica",
    "creame una tarea para ir a la biblioteca a estudiar el lunes que viene",
    "quiero programar un alarma a las 6 de la mañana el lunes que viene",
    "avisar el lunes para la reunion de las 10 de la mañana",
    "creame un recordatorio para ir a cenar el sabado",
    "quiero programar un aviso el domingo 29 de abril porque tengo boda",
    "programame una reunion el miercoles con los del trabajo",
    "programar aviso el dia 7 a las 7",
    "añademe una tarea para la revision el coche el miercoles que viene",
    "quiero programar la cita del 7 de mayo",
    "quiero crear una alarma el 5 a las 8 de la mañana",
    "pon una alarma pasadomañana a las 8 menos cuarto",
    "poner aviso el lunes 15 a las 14:00",
    "avisame para llamar al medico mañana a las 15:00",
    "recuerda que busque lo del viaje a las 9 mañana",
    "programar tarea el jueves 15 a las 3 y media",
    "quiero crear otra tarea el martes que viene a las 9 de la noche",
    "avisar para ir a la revision del coche pasadomañana a las 10 de la mañana",
    "crea un  recordatorio todos los lunes a las 10 de la mañana para poner la lavadora",
    "recordar que vaya a llevarle las compra a mi tia mañan",
    "crear una alarma mañana a las 5 y media de la tarde",
    "añadir aviso el miercoles 20 de mayo",
    "quiero poner un recordatorio",
    "pon un recordatorio",
    "como pongo una alarma",
    "como pongo un recordatorio",
    "poner un recordatorio",
    "poner una alarma",
    "quiero poner un aviso",
    "alarma",
    "recordatorio",
    "como añado una tarea",
    "añadir tarea",

]

calendar = [
    "quiero ver el calendario",
    "calendario",
    "muestrame el calendario",
    "enseñame el calendario",
    "quiero ver todo lo que tengo este mes",
    "que tengo este mes",
    "saca el calendario",
    "quiero ver el calendario",
    "puedes sacar el calendario",
    "puedo ver el calendario",
    "calendario de este mes",
    "quiero ver el calendario de este mes",
    "quiero consultar el calendario",
    "consultar el calendario",
    "quiero ver todos mis recordatorios",
    "ver todos mis avisos",
    "me gustaria ver todas las alarmas de este mes",
    "enseñame todas las tareas del calendario",
    "quiero ver todo lo que hay este mes",
    "enseñame todos mis recordatorios",
    "todas las tareas",
    "tareas calendario",
]

function = ["que eres capaz de hacer",
"que haces",
"que puedes hacer",
"para que sirves",
"como me puedes ayudar",
"para que me sirves",
"como funcionas",
"como funciona esto",
"que eres",
"que te tengo que decir",
"como funcionas",
"que hago ",
"que hago contigo",
"que sabes hacer",
"que sabes hacer",
"que te digo",
"que te puedo decir",
"como puedo poner un aviso",
"como creo cosas",
"como pongo tareas y recordatorios",
"sabes hacer algo mas",
"que deberia decirte",
"cual es tu funcionamiento",
"como hago cosas contigo",
"como hago para que pongas una alarma",
"sabes poner alarmas?",
"ayudame",
"tutorial",
"dime que haces"]


intents = []
labels = []

for i in range(len(create_reminder)):
    intents.append(create_reminder[i])
    labels.append("REMINDER01")

for i in range(len(calendar)):
    intents.append(calendar[i])
    labels.append("CALENDAR00")

for i in range(len(function)):
    intents.append(function[i])
    labels.append("FUNCTION00")

#print(intents,labels)


import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.utils import to_categorical

intents_tokenizer = Tokenizer(num_words = 1000,oov_token = "<OOV>")
intents_tokenizer.fit_on_texts(intents)
seq = intents_tokenizer.texts_to_sequences(intents) 

longest_intent = max(seq, key=len)
pad_len = len(longest_intent)

padded_seq = pad_sequences(seq,maxlen = pad_len, padding='post')

labels_tokenizer = Tokenizer()
labels_tokenizer.fit_on_texts(labels)

label_seq = np.array(labels_tokenizer.texts_to_sequences(labels)) -1
#print(label_seq)
labels_cat = to_categorical(label_seq)
#print(labels_cat)
#print(padded_seq)

model = tf.keras.Sequential([
    tf.keras.layers.Embedding(300, 64, input_length=pad_len),
    tf.keras.layers.Flatten(),
    #//tf.keras.layers.Bidirectional(tf.keras.layers.LSTM(64, return_sequences=True)),
    #tf.keras.layers.GlobalMaxPooling1D(),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dropout(0.5),
    tf.keras.layers.Dense(3, activation='softmax')
])

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

padded_seq = np.array(padded_seq)
labels_cat = np.array(labels_cat)

history = model.fit(padded_seq, labels_cat,
                    epochs=50,
                    batch_size=32,
                    #validation_data=(val_sequence,val_tags)
                   )

frase = ["quiero poner un recordatorio el 21 de marzo"]
frase_tok = intents_tokenizer.texts_to_sequences(frase)
frase_tok = pad_sequences(frase_tok,maxlen = pad_len, padding='post')

print(frase_tok)

print(labels_tokenizer.word_index)

pred = model.predict(frase_tok)
print(pred)

import json

with open('assets/vocabulario_intents.json','w') as f:
    json.dump(intents_tokenizer.word_index,f)

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('assets/modelo_intents.tflite','wb') as f:
    f.write(tflite_model)