FROM registry.access.redhat.com/jboss-eap-6/eap-openshift

MAINTAINER Vinicius Martinez <vinicius@redhat.com>

ADD configure /opt/eap/customization/configure
ADD modules /opt/eap/customization/modules
ADD applications /opt/eap/customization/applications

RUN /opt/eap/customization/configure/setup.sh
RUN /opt/eap/bin/add-user.sh admin redhat*99 --silent

EXPOSE 8080 9990 9999

CMD ["/opt/eap/bin/openshift-launch.sh"]