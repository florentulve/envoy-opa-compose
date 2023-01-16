import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get("sayho")
  sayho(): string {
    return "ho";
  }

  @Get("/sayhi")
  sayhi(): string {
    return "hi";
  }
}
