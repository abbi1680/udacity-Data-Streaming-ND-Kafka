from dataclasses import asdict, dataclass, field
import json
import time
import random

import requests
from confluent_kafka import avro, Consumer, Producer
from confluent_kafka.admin import AdminClient, NewTopic
from confluent_kafka.avro import AvroConsumer, AvroProducer, CachedSchemaRegistryClient
from faker import Faker


faker = Faker()


@dataclass
class Page:
    uri: str = field(default_factory=faker.uri)
    description: str = field(default_factory=faker.uri)
    created: str = field(default_factory=faker.iso8601)


@dataclass
class ClickEvent:
    email: str = field(default_factory=faker.email)
    timestamp: str = field(default_factory=faker.iso8601)
    uri: str = field(default_factory=faker.uri)
    number: int = field(default_factory=lambda: random.randint(0, 999))


def produce():
    """Produces data into the Kafka Topic"""
    p = Producer({"bootstrap.servers": "PLAINTEXT://kafka0:19092"})

    pages = [Page() for _ in range(500)]
    for page in pages:
        p.produce(
            "com.udacity.streams.pages",
            value=json.dumps(asdict(page)),
            key=page.uri,
        )

    # Now start simulating clickevents for the pages
    while True:
        page = random.choice(pages)
        click = ClickEvent(uri=page.uri)
        p.produce(
            "com.udacity.streams.clickevents",
            value=json.dumps(asdict(click)),
            key=click.uri,
        )
        time.sleep(0.1)


def main():
    """Checks for topic and creates the topic if it does not exist"""
    client = AdminClient({"bootstrap.servers": "PLAINTEXT://kafka0:19092"})
    pages = NewTopic("com.udacity.streams.pages", 10, 1)
    clickevents = NewTopic("com.udacity.streams.clickevents", 10, 1)
    try:
        client.create_topics([pages, clickevents])
    except Exception as e:
        print(f"encountered error creating topics: {e}")
    else:
        print("created topics pages and clickevents")

    try:
        produce()
    except KeyboardInterrupt as e:
        print("shutting down")


if __name__ == "__main__":
    main()
