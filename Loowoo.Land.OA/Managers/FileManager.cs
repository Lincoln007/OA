﻿using Loowoo.Common;
using Loowoo.Land.OA.Models;
using Loowoo.Land.OA.Parameters;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Text;
using System.Web;

namespace Loowoo.Land.OA.Managers
{
    public class FileManager : ManagerBase
    {
        public void Save(File file)
        {
            if (file.ID > 0)
            {
                file.UpdateTime = DateTime.Now;
            }
            DB.Files.AddOrUpdate(file);
            DB.SaveChanges();
        }

        public File GetModel(int id)
        {
            return DB.Files.FirstOrDefault(e => e.ID == id);
        }

        public void Delete(int id)
        {
            var entity = DB.Files.FirstOrDefault(e => e.ID == id);
            if (entity != null)
            {
                DB.Files.Remove(entity);
                DB.SaveChanges();
            }
        }

        public void Relation(int[] fileIds, int infoId)
        {
            var entities = DB.Files.Where(e => fileIds.Contains(e.ID));
            foreach (var entity in entities)
            {
                entity.InfoId = infoId;
            }
            DB.SaveChanges();
        }

        public IEnumerable<File> Search(FileParameter parameter)
        {
            var query = DB.Files.AsQueryable();
            if (parameter.InfoId.HasValue)
            {
                query = query.Where(e => e.InfoId == parameter.InfoId.Value);
            }
            return query.OrderBy(e => e.UpdateTime).SetPage(parameter.Page);
        }
    }
}