Proyecto de Sistemas y Tecnologías Web
========

## ReceBlario: tu blog de recetas

Autores:
* [María Rojas Estévez](https://campusvirtual.ull.es/1415/user/view.php?id=15022&course=5678)
* [Rocío Rodríguez Morín](https://campusvirtual.ull.es/1415/user/view.php?id=6590&course=5678)
* [Sem Ramos Herrera](https://campusvirtual.ull.es/1415/user/view.php?id=2643&course=5678)

---------------------------------------

Receblario es tu blog, en el que puedes publicar tus recetas de cocina y consultar las recetas de los demás usuarios.

¡Comenta!
> Recibe comentarios o hazlos tu sobre una receta. Entre todos podemos mejorar

¡Publica tus recetas!
> ¿Tienes una receta especial? Compártela con nosotros

Toma nota
> Siempre es una buena idea echarle un ojo a las recetas de otros cocineros, seguro que encontramos algo que nos gustaría introducir a nuestra propia receta.

## Tecnologías que hemos utilizado

Sinatra
-------
> Sinatra is a free and open source software web application library and domain-specific language written in Ruby. It is an alternative to other Ruby web application frameworks such as Ruby on Rails, Merb, Nitro, and Camping. It is dependent on the Rack web server interface. Designed and developed by Blake Mizerany, Sinatra is small and flexible. It does not follow the typical model–view–controller pattern used in other frameworks, such as Ruby on Rails. Instead, Sinatra focuses on "quickly creating web-applications in Ruby with minimal effort." Some notable companies and institutions that use Sinatra include Apple, BBC, the British Government's Government Digital Service, LinkedIn, the National Security Agency, Engine Yard, Heroku, GitHub, and Songbird. Travis CI provides much of the financial support for Sinatra's development.

Fuente: [Sinatra - Wikipedia](http://en.wikipedia.org/wiki/Sinatra_(software))

DataMapper
----------
> DataMapper is an Object Relational Mapper written in Ruby. The goal is to create an ORM which is fast, thread-safe and feature rich.

Fuente: [DataMapper.org](http://datamapper.org/)

Instrucciones
-------------

**Para ejecutarlo de forma local**

1. Clona este repositorio para disponer del código:

        $ git@github.com:RocioDSI/Proyecto.git

2. Instala las gemas correspondientes para que todo funcione correctamente:

        $ bundle install

En caso de error, intentar:

        $ bundle install --without production

3. Ejecuta el programa de forma manual o mediante Rake:

        $ rackup
        $ rake

5. Abre el navegador y ve al puerto [9292](http://localhost:9292/) para ver la aplicación:


**Para ver la aplicación desplegada**

Abre tu navegador y accede a [ReceBlario en Heroku](http://receblario.herokuapp.com/):

        http://receblario.herokuapp.com/

---
Sistemas y Tecnologías Web

Escuela Técnica Superior de Ingeniería Informática

Universidad de La Laguna
