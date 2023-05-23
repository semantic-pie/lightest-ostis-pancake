#!/bin/bash

git clone https://github.com/ostis-ai/sc-machine
git clone https://github.com/ostis-ai/sc-web
git clone https://github.com/ostis-apps/ostis-example-app

cd sc-machine
git checkout 0.7.0-Rebirth

cd ../sc-web
git checkout 0.7.0-Rebirth

cd ../ostis-example-app
git checkout 0.7.0
mv kb ..
cd ..
rm -rf ostis-example-app

echo 'sc-machine/problem-solver/cxx/exampleModule/specifications/agent_of_isomorphic_search' >> repo.path
echo 'problem-solver/cxx/exampleModule/specifications/agent_of_subdividing_search' >> repo.path
echo 'kb' >> repo.path



