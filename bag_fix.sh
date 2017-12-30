#Item unified_inventory:bag_small
#Item unified_inventory:bag_medium
#Item unified_inventory:bag_large

#Item bags:small
#Item bags:medium
#Item bags:large

find ./ -type f -exec sed -i 's/bags:small/unified_inventory:bag_small/g' {} \;
find ./ -type f -exec sed -i 's/bags:medium/unified_inventory:bag_medium/g' {} \;
find ./ -type f -exec sed -i 's/bags:large/unified_inventory:bag_large/g' {} \;
