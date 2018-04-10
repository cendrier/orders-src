import os
import unittest
from os.path import expanduser

from util.Docker import Docker


class JavaServices(unittest.TestCase):
    def test_maven(self):
        script_dir = os.path.dirname(os.path.realpath(__file__))
        code_dir = script_dir + "/.."
        home = expanduser("~")
        hosthome = format(os.getenv('HOST_HOME'))
        hostcode_dir = format(os.getenv('HOST_CODE_DIR'))
        command = ['docker', 'run', '--rm',
                   '-v', hosthome + '/.m2:/root/.m2',
                   '-v', hosthome + '/.m2/.sonar:/root/.sonar',
                   '-v', hostcode_dir + ':/usr/src/mymaven',
                   '-w', '/usr/src/mymaven',
                   'maven:3.2-jdk-8',
                   'mvn',
                   '-Dsonar.login=' + os.getenv('SONAR_TOKEN'),
                   '-Dsonar.host.url=' + os.getenv('SONAR_HOST'),
                   '-Dsonar.java.binaries=target/classes',
                   '-Dsonar.sources=src/main/java',
                   'verify',
                   'jacoco:report',
                   'sonar:sonar']
        print(Docker().execute(command))


if __name__ == '__main__':
    unittest.main()
