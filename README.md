# Proyecto basico con Apache Kafka e integracion con Java

El archivo ´main.sh´ nos dara un script para automatizar las tareas basicas en apache kafka.


Por su parte el codigo java es para ver como aplicamos el concepto de colas a programacion!


##### Objetivos:

- Identificar el funcionamiento de kafka 
- Crear un Producto Mínimo Viable (PMV), un producto que nos permite demostrar kafka sin tanta complejidad 
- Aprovechar el bash scripting para automatizar tareas

##### Mejoras o siguientes pasos:

- Separar el producer y el consumer en microservicios
- Usar el modulo de spring cloud
- "dockerizar" tanto el servidor kafka y los microservisios

### Ejecutar la app

- tener instalado maven

```bash

apt install mvn -y



# Ejecutamos dentro del proyecto
mvn clean package -DskipTests

# Ejecutamos el .jar que genera
java -jar target/ApacheKafka-Java-1.0-SNAPSHOT.jar
```