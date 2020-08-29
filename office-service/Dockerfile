from node as build
copy index.js /src/
copy package* /src/
run cd /src && \
    npm install
from node
copy --from=build /src/node_modules /office/node_modules/
copy index.js /office/
workdir /office
cmd ["node", "index.js"]
