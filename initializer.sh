#!/bin/bash

git clone https://github.com/ostis-ai/sc-machine
git clone https://github.com/ostis-ai/sc-web

cd sc-machine
git checkout 0.7.0-Rebirth

cd ../sc-web
git checkout 0.7.0-Rebirth
cd ..

echo 'sc-machine/problem-solver/cxx/exampleModule/specifications/agent_of_isomorphic_search' >> repo.path
echo 'sc-machine/problem-solver/cxx/exampleModule/specifications/agent_of_subdividing_search' >> repo.path



