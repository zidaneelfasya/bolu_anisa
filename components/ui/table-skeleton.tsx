import { Skeleton } from "@/components/ui/skeleton";

interface TableSkeletonProps {
  rowCount?: number;
  columnCount?: number;
}

export function TableSkeleton({ rowCount = 5, columnCount = 5 }: TableSkeletonProps) {
  return (
    <div className="w-full space-y-4">
      {/* Search / Header Actions Placeholder */}
      <div className="flex items-center justify-between">
        <Skeleton className="h-10 w-[250px]" />
        <Skeleton className="h-10 w-[120px]" />
      </div>

      {/* Table Header Placeholder */}
      <div className="rounded-md border">
        <div className="border-b px-4 py-3 flex gap-4 bg-muted/50">
          {Array.from({ length: columnCount }).map((_, i) => (
            <Skeleton key={`th-${i}`} className="h-6 w-full" />
          ))}
        </div>
        
        {/* Table Rows Placeholder */}
        <div className="divide-y">
          {Array.from({ length: rowCount }).map((_, rowIndex) => (
            <div key={`tr-${rowIndex}`} className="px-4 py-4 flex gap-4">
              {Array.from({ length: columnCount }).map((_, colIndex) => (
                <Skeleton key={`td-${rowIndex}-${colIndex}`} className="h-5 w-full" />
              ))}
            </div>
          ))}
        </div>
      </div>
      
      {/* Pagination Placeholder */}
      <div className="flex items-center justify-end space-x-2 py-4">
        <Skeleton className="h-8 w-[100px]" />
        <Skeleton className="h-8 w-[100px]" />
      </div>
    </div>
  );
}
