import { response } from "./index";
import * as EraPointsService from "../services/EraPoints";

export default class EraPointsController {
  public static async getEraPoints(context: any): Promise<any> {
    const { address, last } = context.params;
    response(context, 200, await EraPointsService.getEraPoints(address));
  }

  public static async getTotalEraPoints(context: any): Promise<any> {
    response(context, 200, await EraPointsService.getTotalEraPoints());
  }
}
