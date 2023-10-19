FROM python:3.11.6-slim-bullseye

RUN pip install pylint

COPY . /code

WORKDIR /code

CMD /code/bug-repro
