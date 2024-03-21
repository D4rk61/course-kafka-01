package org.example.kafka.producer;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class ProducerTopic {
    public static final Logger log = LoggerFactory.getLogger(ProducerTopic.class);
    private static String topic = "topic1";
    private static String key = "Mensaje No. ";
    private static String value = "Hola mundo";

    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();
        Properties props=new Properties();
        // broker de kafka
        props.put("bootstrap.servers","localhost:9092");
        // para cuando requerimos si o si que la informacion llegue
        props.put("acks","1");
        props.put("key.serializer",
            "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer",
            "org.apache.kafka.common.serialization.StringSerializer");

        props.put("linger.ms",
                "11"); // optimo !!!

        props.put("batch.size", 16384); // Tamaño del lote en bytes
        props.put("buffer.memory", 33554432); // Tamaño del búfer de memoria en bytes


        try(Producer<String, String> producer = new KafkaProducer<>(props)) {
            for(int i = 0 ; i < 100000; i++) {
                producer.send(new ProducerRecord<String, String>(
                    topic,
                    key + String.valueOf(i),
                    value));
            }
            producer.flush();
        }
        log.info("Processing time = {} ms ", (System.currentTimeMillis() - startTime));
    }
}
