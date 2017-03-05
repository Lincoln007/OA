﻿using Loowoo.Land.OA.Managers;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;

namespace Loowoo.Land.OA.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
            GlobalConfiguration.Configuration.Filters.Add(new WebApiExceptionFilterAttribute());
#if DEBUG
            GlobalConfiguration.Configuration.MessageHandlers.Add(new CorsHandler());
#endif
            var formatter = GlobalConfiguration.Configuration.Formatters.JsonFormatter;
            formatter.SerializerSettings.PreserveReferencesHandling = Newtonsoft.Json.PreserveReferencesHandling.Objects;
        }

        public override void Init()
        {
            this.PostAuthenticateRequest += (sender, e) => HttpContext.Current.SetSessionStateBehavior(System.Web.SessionState.SessionStateBehavior.Required);
            base.Init();
        }
        protected virtual void Application_BeginRequest()
        {
            OneContext.Begin();
        }
        protected virtual void Application_EndRequest()
        {
            OneContext.End();
        }
    }
}
