# Assignment: Writing A Compose File #

* Build a basic compose file for a Drupal content management system website (check Docker Hub).

* Use the <span style="color:red">drupal</span> image along with the <span style="color:red">postgres</span> image

* Use <span style="color:red">ports</span> to expose Drupal on 8080 so you can use <span style="color:blue">__localhost:8080__</span>

* Be sure to set <span style="color:red">POSTGRES_PASSWORD</span> for postgres

* Walk through Drupal setup via browser

* Tip: Drupal assumes DB is <span style="color:red">localhost</span>, but it's service name (i.e. DNS name)

* Extra Credit: Use volumes to stoer Drupal unique data 