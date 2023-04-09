# horas
    # a las x (5)/(17)(17:00) DONE (CONFIGURAR TOKENIZADOR PARA ELIMINAR EL TOKEN DE : Y JUNTAR LOS NUMEROS) hora1
    # a las x y y OK 
    # a las x menos y OK 
    # en x horas 
    # en x minutos
    # en x horas y y
    # + de la noche
    # de la mañana
    # del mediodía
    # de la tarde
    # de la madrugada

# fechas
    # mañana ok
    # pasado mañana ok 
    # pasao mañana ok
    # pasadomañana ok
    # el x que viene (día semana) ok
    # el x(día semana) ok
    # el x ok 
    # el x de y ok
    # el dia x de y ok
    # el día x ok 
    # el x que viene ok
    # el x de la semana que viene ok 
    # el x dentro de x semanas pdt
    # dentro de x días pdt
    # en x días pdt

# start + fecha + horas + conc
    # generar/genera/establece/estableces/pon/poner/crea/crear/programa/programar una tarea
    # generar/genera/establece/estableces/pon/poner/crea/crear/programa/programar un recordatorio 
    # generar/genera/establece/estableces/pon/poner/crea/crear/programa/programar un aviso
    # generar/genera/establece/estableces/pon/poner/crea/crear/programa/programar una alarma
    # generar/genera/establece/estableces/pon/poner/crea/crear/programa/programar una reunion
    # creame/programame/ponme un/una tarea/recordatorio/aviso/alarma
    # configura
    # recordar/avisar/recuerdame/avisame 

# EJEMPLO: pon una tarea el día 5 a las 17:00 para ir al x 
    # para ir al (x)
    # para hacer (el x, la x, los x, las x)
    # para el (medico/fisio/dentista/cena)
    # para x(verbo)
    # reunion con x, con el equipo de x
    # para llamar a/al x


import random as rd
import json

def hora1():
    hora_num = rd.randint(0,24)
    string = f"a las {hora_num}"
    tags = [["<O>"],["<O>"],["<TIME>"]]

    return string, tags

def hora1min():
    hora_num = rd.randint(0,24)
    min_num = rd.randint(0,59)
    string = f"a las {hora_num} y {min_num}"
    tags = [["<O>"],["<O>"],["<TIME>"],["<O>"],["<TIME>"]]

    return string, tags

def hora1min2():
    hora_num = rd.randint(0,24)
    min_num = rd.randint(0,59)
    string = f"a las {hora_num} {min_num}"
    tags = [["<O>"],["<O>"],["<TIME>"],["<TIME>"]]

    return string, tags

def hora2():
    hora_num = rd.randint(0,24)
    periodos = ["media","cuarto","veinte","diez","cinco"]
    string = f"a las {hora_num} y {periodos[rd.randint(0,4)]}"
    tags = [["<O>"],["<O>"],["<TIME>"],["<O>"],["<TIME>"]]

    return string, tags

def hora3():
    hora_num = rd.randint(0,24)
    periodos = ["cuarto","veinte","diez","cinco"]
    string = f"a las {hora_num} menos {periodos[rd.randint(0,3)]}"
    tags = [["<O>"],["<O>"],["<TIME>"],["<MENOS>"],["<TIME>"]]

    return string, tags

def franja():
    
    peri = ["mañana","noche","tarde","madrugada"]
    string = f"de la {peri[rd.randint(0,3)]}"
    tags = [["<O>"],["<O>"],["<TIME>"]]

    return string, tags

def franja2():

    string = f"del mediodia"
    tags = [["<O>"],["<TIME>"]]

    return string, tags

def x_horas_1():
    hora_num = rd.randint(1,23)

    if (rd.randint(1,11)<2):

        string = f"en {hora_num} horas"
        tags = [["<O>"],["<TIME>"],["<O>"]]
    
    else:
        string = f"en {1} hora"
        tags = [["<O>"],["<TIME>"],["<O>"]]

    return string, tags

def x_horas_2():
    hora_num = rd.randint(1,23)
    periodos = ["media","cuarto","veinte","diez","cinco"]
    if (rd.randint(1,11)<2):

        string = f"en {hora_num} horas y {periodos[rd.randint(0,4)]}"
        tags = [["<O>"],["<TIME>"],["<O>"],["<O>"],["<TIME>"]]
    
    else:
        string = f"en {1} hora y {periodos[rd.randint(0,4)]}"
        tags = [["<O>"],["<TIME>"],["<O>"],["<O>"],["<TIME>"]]

    return string, tags

def x_minutos():
    min_num = rd.randint(1,59)

    if(min_num == 1):
       string = f"en {1} minuto" 
    else:
       string = f"en {min_num} minutos" 

    tags = [["<O>"],["<TIME>"],["<TIME>"]]

    return string, tags

def fecha1():
    extrastr, extratags = hora1()
    if rd.randint(0,1) == 1:
        strs = ["hoy","mañana","pasadomañana","pasaomañana"]
        string = f"{strs[rd.randint(0,3)]} "+extrastr
        tags = [["<DAY>"],extratags[0],extratags[1],extratags[2]]
    else:
        strs = ["pasado mañana","pasao mañana"]
        string = f"{strs[rd.randint(0,1)]} "+extrastr
        tags = [["<DAY>"],["<DAY>"],extratags[0],extratags[1],extratags[2]]

    return string,tags

dias = ["lunes","martes","miercoles","jueves","viernes","sabado","domingo"]

def fecha2():
    dia_rand = rd.randint(0,6)
    if rd.randint(0,1) == 1:
        string = f"el {dias[dia_rand]} que viene"
        tags = [["<O>"],["<DAY>"],["<O>"],["<O>"]]
    else:
        string = f"el {dias[dia_rand]}"
        tags = [["<O>"],["<DAY>"]]

    return string,tags

def fechadddd():
    dia_rand = rd.randint(0,6)
    
    string = f"el {dias[dia_rand]} {rd.randint(1,31)}"
    tags = [["<O>"],["<DAY>"],["<DAY>"]]

    return string,tags

meses = ["enero","febrero","marzo","abril","mayo","junio","julio","agosto","septiembre","octubre","noviembre","diciembre"]

def fecha3():
    dia_rand = rd.randint(0,31)
    if rd.randint(0,1) == 1:
        string = f"el {dia_rand} de {meses[rd.randint(0,11)]}"
        tags = [["<O>"],["<DAY>"],["<O>"],["<MONTH>"]]

    else:
        string = f"el {dia_rand}"
        tags = [["<O>"],["<DAY>"]]      

    return string,tags  

def fecha4():
    dia_rand = rd.randint(0,31)
    if rd.randint(0,1) == 1:
        string = f"el dia {dia_rand} de {meses[rd.randint(0,11)]}"
        tags = [["<O>"],["<O>"],["<DAY>"],["<O>"],["<MONTH>"]]

    else:
        string = f"el dia {dia_rand}"
        tags = [["<O>"],["<O>"],["<DAY>"]]      

    return string,tags  

def fecha5():
    dia_rand = rd.randint(0,6)
    if rd.randint(0,1) == 1:
        string = f"el {dias[dia_rand]} que viene"
        tags = [["<O>"],["<DAY>"],["<O>"],["<O>"]]
    else:
        string = f"el {dias[dia_rand]} de la semana que viene"
        tags = [["<O>"],["<DAY>"],["<O>"],["<O>"],["<O>"],["<O>"],["<O>"]]

    return string,tags





frases = []
etiquetas = []
funciones = [fecha5,hora1,fecha4,franja2,hora1min,fecha3,hora2,franja,x_horas_1,x_minutos,fecha1,hora1min2,fecha2,x_horas_2,fecha4,hora3,fechadddd,fecha3]

for funcion in funciones:
    for i in range(700):
        f, t = funcion()
        #print (f)
        f_sp = f.split()
        
        for j in range(len(f_sp)):
            tag = t[j][0]
            frase = ""
            if(j-1 < 0):
                frase += "NULL "
            else:
                frase += f"{f_sp[j-1]} "

            frase += f"{f_sp[j]} "

            if(j+1 > len(f_sp)-1):
                frase += "NULL"
            else:
                frase += f"{f_sp[j+1]} "

            #print(frase, tag)
            frases.append(frase)
            etiquetas.append(tag)

#print(frases,tags)
num_frases = len(etiquetas)
print(num_frases)

import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.utils import to_categorical

palabras_tokenizador = Tokenizer(num_words = 1000, oov_token = "<OOV>")
palabras_tokenizador.fit_on_texts(frases)
seq = palabras_tokenizador.texts_to_sequences(frases) 

print(palabras_tokenizador.word_index)

with open('assets/vocabulario.json','w') as f:
    json.dump(palabras_tokenizador.word_index,f)

etiquetas_tokenizador = Tokenizer()
etiquetas_tokenizador.fit_on_texts(etiquetas) 

label_seq = np.array(etiquetas_tokenizador.texts_to_sequences(etiquetas)) - 1

print(label_seq)
print(etiquetas_tokenizador.word_index)

labels = to_categorical(label_seq)

print(labels)

model = tf.keras.Sequential([
    tf.keras.layers.Embedding(150, 64, input_length=3),
    tf.keras.layers.Flatten(),
    #//tf.keras.layers.Bidirectional(tf.keras.layers.LSTM(64, return_sequences=True)),
    #tf.keras.layers.GlobalMaxPooling1D(),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dense(64, activation='relu'),
    tf.keras.layers.Dropout(0.5),
    tf.keras.layers.Dense(5, activation='softmax')
])

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])

seq = np.array(seq)
labels = np.array(labels)

history = model.fit(seq, labels,
                    epochs=3,
                    batch_size=32,
                    #validation_data=(val_sequence,val_tags)
                   )

frase = ["el 21 de"]

frase_tok = palabras_tokenizador.texts_to_sequences(frase)
#frase_tok = pad_sequences(frase_tok,padding='post',maxlen = 3)

pred = model.predict(frase_tok)

print(pred)



frase = ["las 5:30"]

frase_tok = palabras_tokenizador.texts_to_sequences(frase)

print(frase_tok)
print(etiquetas_tokenizador.word_index)
#frase_tok = pad_sequences(frase_tok,padding='post',maxlen = 3)

#print(frase_tok)

pred = model.predict(frase_tok)

print(pred)
print(etiquetas_tokenizador.word_index)


converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open('assets/modelo_ventanas.tflite','wb') as f:
    f.write(tflite_model)

