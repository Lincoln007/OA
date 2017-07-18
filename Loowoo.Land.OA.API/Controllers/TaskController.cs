﻿using Loowoo.Common;
using Loowoo.Land.OA.Models;
using System;
using System.Linq;
using System.Web;
using System.Web.Http;

namespace Loowoo.Land.OA.API.Controllers
{
    public class TaskController : ControllerBase
    {
        [HttpGet]
        public object Model(int id)
        {
            return Core.TaskManager.GetModel(id);
        }

        [HttpGet]
        public void UpdateZRR(int id)
        {
            var info = Core.FormInfoManager.GetModel(id);
            var flow = Core.FlowManager.Get(info.Form.FLowId);
            var firstNode = flow.GetFirstNode();
            var secondNode = flow.GetNextStep(firstNode.ID);
            if (secondNode != null)
            {
                var lastSecondNodeData = info.FlowData.GetLastNodeDataByNodeId(secondNode.ID);
                if (lastSecondNodeData != null)
                {
                    var model = Core.TaskManager.GetModel(id);
                    model.ZRR_ID = lastSecondNodeData.UserId;
                    Core.TaskManager.Save(model);
                }
            }
        }

        [HttpGet]
        public object List(string searchKey = null, FlowStatus? status = null, int page = 1, int rows = 20)
        {
            var form = Core.FormManager.GetModel(FormType.Task);
            var parameter = new FormInfoParameter
            {
                FormId = form.ID,
                Status = status,
                Page = new PageParameter(page, rows),
                UserId = CurrentUser.ID,
                SearchKey = searchKey
            };
            var datas = Core.TaskManager.GetList(parameter);
            return new PagingResult
            {
                List = datas.Select(e => new
                {
                    e.ID,
                    e.MC,
                    e.JH_SJ,
                    e.LY,
                    e.LY_LX,
                    e.XB_DW,
                    e.ZB_DW,
                    ZRR_Name = e.ZRR == null ? null : e.ZRR.RealName,
                    e.GZ_MB,
                    e.Info.FormId,
                    e.Info.CreateTime,
                    e.Info.UpdateTime,
                    e.Info.FlowStep,
                    e.Info.FlowDataId,
                }),
                Page = parameter.Page
            };
        }

        [HttpPost]
        public void Save([FromBody]Task data)
        {
            var form = Core.FormManager.GetModel(FormType.Task);
            var isAdd = data.ID == 0;
            //判断id，如果不存在则创建forminfo
            if (data.ID == 0)
            {
                data.Info = new FormInfo
                {
                    FormId = form.ID,
                    PostUserId = CurrentUser.ID,
                    Title = data.MC
                };
                Core.FormInfoManager.Save(data.Info);
            }
            else
            {
                data.Info = Core.FormInfoManager.GetModel(data.ID);
                data.Info.Title = data.MC;
            }
            if (data.Info.FlowDataId == 0)
            {
                data.Info.Form = form;
                Core.FlowDataManager.CreateFlowData(data.Info);
            }
            data.ID = data.Info.ID;
            Core.TaskManager.Save(data);

            Core.FeedManager.Save(new Feed
            {
                InfoId = data.ID,
                Title = data.MC,
                Description = data.GZ_MB,
                FromUserId = CurrentUser.ID,
                Action = isAdd ? UserAction.Create : UserAction.Update,
            });
        }

        [HttpGet]
        public object TodoList(int taskId)
        {
            return Core.TaskManager.GetTodoList(taskId).Select(e => new
            {
                e.ID,
                e.Completed,
                e.Content,
                e.CreateTime,
                e.ScheduleTime,
                e.TaskId,
                e.ToUserId,
                e.CreatorId,
                CreatorName = e.Creator.RealName,
                ToUserName = e.ToUser == null ? null:e.ToUser.RealName,
                e.UpdateTime
            });
        }

        [HttpPost]
        public void SaveTodo(TaskTodo model)
        {
            model.CreatorId = CurrentUser.ID;
            Core.TaskManager.SaveTodo(model);
            //创建自由流程，转发给此人
            
            Core.FeedManager.Save(new Feed
            {
                FromUserId = model.CreatorId,
                ToUserId = model.ToUserId,
                InfoId = model.TaskId,
                Title = model.Content,
                Type = FeedType.Info,
                Action = UserAction.Create,
            });
        }

        [HttpGet]
        public void UpdateTodoStatus(int id)
        {
            var model = Core.TaskManager.GetTodo(id);
            model.Completed = !model.Completed;
            model.UpdateTime = DateTime.Now;
            Core.TaskManager.SaveTodo(model);
        }

        [HttpDelete]
        public void DeleteTodo(int id)
        {
            Core.TaskManager.DeleteTodo(id);
        }

        [HttpGet]
        public object ProgressList(int taskId)
        {
            return Core.TaskManager.GetProgressList(taskId).Select(e => new
            {
                e.ID,
                e.TaskId,
                e.CreateTime,
                e.Content,
                e.UserId,
                e.User.RealName,
            });
        }

        [HttpPost]
        public void SaveProgress(TaskProgress model)
        {
            if (model.TaskId == 0 || string.IsNullOrEmpty(model.Content))
            {
                throw new System.Exception("参数不正确");
            }
            model.UserId = CurrentUser.ID;
            Core.TaskManager.SaveProgress(model);
        }

        [HttpDelete]
        public void DeleteProgress(int id)
        {
            var model = Core.TaskManager.GetProgress(id);
            if (model != null)
            {
                if (model.UserId != CurrentUser.ID)
                {
                    throw new HttpException(403, "forbidden");
                }
                Core.TaskManager.DeleteProgress(model);
            }
        }
    }
}
