using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace inventory_system.Entities
{
    public class Supplier
    {
        public int Id { get; set; }
        public string UniqueIdentifier { get; set; }
        public string Name { get; set; }
        public string Contact { get; set; }

        private ICollection<Product> Products { get; set; }
        private ICollection<SupplierTag> SupplierTags { get; set; }
    }

}
