FROM python:3.11.6-slim-bullseye

RUN pip install pylint

COPY . /code

CMD /code/bug-repro
