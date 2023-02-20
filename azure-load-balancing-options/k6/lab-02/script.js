import http from 'k6/http';
import { sleep } from 'k6';

export default function () {
  http.get('http://iac-ws2-norwayeast-alb.norwayeast.cloudapp.azure.com');
  sleep(1);
}
