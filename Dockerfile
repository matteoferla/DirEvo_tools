FROM centos/python-36-centos7
# s2i build https://github.com/matteoferla/pedel2.git  centos/python-36-centos7 python-docker-pedel
WORKDIR /opt/app-root/src
COPY . /opt/app-root/src/
ENTRYPOINT ["container-entrypoint"]


EXPOSE  8080
USER 1001

# Unfortunately had to split requirements up to make Openshift work. Docker is fine.
RUN pip install -r requirements.txt
RUN pip install -r requirements_extra.txt
CMD ["python", "app.py", "-p 8080"]