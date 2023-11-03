import express from 'express';
import cors from 'cors';
import { getRoutes, postRoutes, DEFAULT_ROOT_PATH, DEFAULT_RUN_PORT } from './routes';
import bodyParser from 'body-parser';

/** ######### ROUTER APP ######### */
const app = express();
const router = express.Router();

/** ######### CORS AND BODY PARSE ######### */
app.use(cors());
app.use(bodyParser.json());
app.use(express.urlencoded({ extended: true }));

/** ######### REGISTERH ROOT PATH ######### */
app.use(DEFAULT_ROOT_PATH, router);

getRoutes.forEach(({ path }) => router.get(path, (req, res) => res.send("scccsdfsfsf")));
postRoutes.forEach(({ path, controllerFunc}) => router.post(path, controllerFunc));

const Run = (port?: number) => {
    const p = port ?? DEFAULT_RUN_PORT;
    app.listen(p, () => {
        console.log(`The FISCO BCOS Server is Running: ${p}`);
    });
}

Run();