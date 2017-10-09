FROM centos/python-36-centos7
# s2i build https://github.com/matteoferla/pedel2.git  centos/python-36-centos7 python-docker-pedel
WORKDIR /opt/app-root/src
COPY . /opt/app-root/src/
ENTRYPOINT ["container-entrypoint"]


EXPOSE  8000
USER 1001

RUN pip install -r requirements.txt
CMD ["python", "app.py", "-p 8000"]